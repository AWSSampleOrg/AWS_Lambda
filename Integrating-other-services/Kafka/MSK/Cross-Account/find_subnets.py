#!/usr/bin/env python
"""Find VPC/subnet combinations usable for cross-account MSK -> Lambda.
Multi-VPC private connectivity constrains the pairing:
  "you must have the same number of client subnets as cluster subnets. You must
   also make sure that Availability Zone IDs are same for the client subnet and
   cluster subnet."
  -- https://docs.aws.amazon.com/msk/latest/developerguide/aws-access-mult-vpc.html
AZ *names* (us-east-1a) map to different physical AZs per account, so the match
has to be done on AZ IDs (use1-az1). That is what makes this tedious by hand and
is the whole point of this script.
"""
import argparse
import itertools
import sys
import boto3

# MSK requires the broker count to be a multiple of the AZ count, and the
# template asks for 2 brokers, so 2 subnets per side is the default.
DEFAULT_AZS = 2

def gateway_kind(ec2, subnet_id, vpc_id):
    """Classify a subnet's default route: 'igw', 'nat', 'blackhole', or 'none'.
    The route's State matters: a route pointing at a deleted NAT gateway stays
    in the table as State=blackhole and carries no traffic, so treating it as
    NAT egress would be wrong.
    """
    tables = ec2.describe_route_tables(
        Filters=[{"Name": "association.subnet-id", "Values": [subnet_id]}]
    )["RouteTables"]
    if not tables:
        # No explicit association means the VPC main route table applies.
        tables = ec2.describe_route_tables(
            Filters=[
                {"Name": "vpc-id", "Values": [vpc_id]},
                {"Name": "association.main", "Values": ["true"]},
            ]
        )["RouteTables"]
    found = "none"
    for table in tables:
        for route in table.get("Routes", []):
            if route.get("DestinationCidrBlock") != "0.0.0.0/0":
                continue
            if route.get("State") != "active":
                found = "blackhole"
                continue
            if route.get("NatGatewayId"):
                return "nat"
            if str(route.get("GatewayId", "")).startswith("igw-"):
                return "igw"
    return found

def interface_endpoint_services(ec2, vpc_id):
    """Interface endpoint service names already present in the VPC.
    A second endpoint for the same service with PrivateDnsEnabled=true is
    rejected, so an existing sts/lambda endpoint makes the Lambda template fail
    in on-demand mode.
    """
    endpoints = ec2.describe_vpc_endpoints(
        Filters=[
            {"Name": "vpc-id", "Values": [vpc_id]},
            {"Name": "vpc-endpoint-type", "Values": ["Interface"]},
        ]
    )["VpcEndpoints"]
    return {e["ServiceName"].rsplit(".", 1)[-1] for e in endpoints}

def survey(profile, region):
    """Collect every subnet in the account, keyed by VPC then AZ ID."""
    session = boto3.Session(profile_name=profile, region_name=region)
    ec2 = session.client("ec2")
    account = session.client("sts").get_caller_identity()["Account"]
    vpcs = {v["VpcId"]: v for v in ec2.describe_vpcs()["Vpcs"]}
    byvpc = {}
    for subnet in ec2.describe_subnets()["Subnets"]:
        vpc_id = subnet["VpcId"]
        entry = {
            "SubnetId": subnet["SubnetId"],
            "AzId": subnet["AvailabilityZoneId"],
            "Az": subnet["AvailabilityZone"],
            "FreeIps": subnet["AvailableIpAddressCount"],
            "Gateway": gateway_kind(ec2, subnet["SubnetId"], vpc_id),
            "Name": next(
                (t["Value"] for t in subnet.get("Tags", []) if t["Key"] == "Name"), ""
            ),
        }
        byvpc.setdefault(vpc_id, {}).setdefault(entry["AzId"], []).append(entry)
    # One subnet per AZ ID is enough; keep the roomiest, preferring private.
    for azs in byvpc.values():
        for az_id, subnets in azs.items():
            subnets.sort(key=lambda s: (s["Gateway"] == "igw", -s["FreeIps"]))
    return {
        "Profile": profile,
        "Account": account,
        "Vpcs": vpcs,
        "ByVpc": byvpc,
        "Endpoints": {v: interface_endpoint_services(ec2, v) for v in byvpc},
    }

def score(cluster_subnets, function_subnets, function_endpoints):
    """Higher is better.
    Private beats public. Then: no endpoint collision, because that one is a
    hard deploy failure. Then NAT on the client subnets, which lets on-demand
    mode reach STS even if the endpoints misbehave. Roomier breaks ties.
    """
    subnets = cluster_subnets + function_subnets
    private = sum(1 for s in subnets if s["Gateway"] != "igw")
    # An existing sts/lambda endpoint collides with the on-demand template.
    collision = len({"sts", "lambda"} & function_endpoints)
    nat = sum(1 for s in function_subnets if s["Gateway"] == "nat")
    free = min(s["FreeIps"] for s in subnets)
    return (private, -collision, nat, free)

def combinations(cluster, function, az_count):
    shared = set()
    for cluster_vpc, cluster_azs in cluster["ByVpc"].items():
        for function_vpc, function_azs in function["ByVpc"].items():
            shared |= {
                (cluster_vpc, function_vpc, combo)
                for combo in itertools.combinations(
                    sorted(set(cluster_azs) & set(function_azs)), az_count
                )
            }
    results = []
    for cluster_vpc, function_vpc, az_ids in shared:
        cluster_subnets = [cluster["ByVpc"][cluster_vpc][a][0] for a in az_ids]
        function_subnets = [function["ByVpc"][function_vpc][a][0] for a in az_ids]
        endpoints = function["Endpoints"][function_vpc]
        results.append(
            {
                "AzIds": az_ids,
                "ClusterVpc": cluster_vpc,
                "FunctionVpc": function_vpc,
                "ClusterSubnets": cluster_subnets,
                "FunctionSubnets": function_subnets,
                "Endpoints": endpoints,
                "Score": score(cluster_subnets, function_subnets, endpoints),
            }
        )
    results.sort(key=lambda r: r["Score"], reverse=True)
    return results

def describe(side, vpc_id, subnets):
    cidr = side["Vpcs"][vpc_id]["CidrBlock"]
    print(f"    {vpc_id} ({cidr}) account={side['Account']} profile={side['Profile']}")
    for s in subnets:
        label = f" {s['Name']}" if s["Name"] else ""
        print(
            f"      {s['SubnetId']}  {s['AzId']} ({s['Az']})  "
            f"{s['FreeIps']} free IPs  default-route={s['Gateway']}{label}"
        )

def report(result, cluster, function, az_count):
    print(f"  AZ IDs: {','.join(result['AzIds'])}")
    print("  MSK side (cluster subnets)")
    describe(cluster, result["ClusterVpc"], result["ClusterSubnets"])
    print("  Lambda side (client subnets)")
    describe(function, result["FunctionVpc"], result["FunctionSubnets"])
    collision = {"sts", "lambda"} & result["Endpoints"]
    if collision:
        print(
            f"  WARNING: {result['FunctionVpc']} already has interface endpoints for "
            f"{sorted(collision)}. The Lambda template creates its own with "
            "PrivateDnsEnabled=true, which fails while a duplicate exists. "
            "Deploy with ProvisionedMode=true, or reuse the existing endpoints."
        )
    if all(s["Gateway"] in ("none", "blackhole") for s in result["FunctionSubnets"]):
        print(
            "  NOTE: no working default route on the client subnets. On-demand mode "
            "then depends entirely on the sts/lambda endpoints the template creates."
        )
    subnet_args = ["PrivateSubnetAId", "PrivateSubnetCId", "PrivateSubnetDId"][:az_count]
    print()
    print("  MSK/deploy.sh")
    print(f"        FunctionAccountId={function['Account']} \\")
    print(f"        VpcId={result['ClusterVpc']} \\")
    for arg, s in zip(subnet_args, result["ClusterSubnets"]):
        print(f"        {arg}={s['SubnetId']} \\")
    print("  Lambda/deploy.sh")
    print(f"    VpcId={result['FunctionVpc']} \\")
    for arg, s in zip(subnet_args, result["FunctionSubnets"]):
        print(f"    {arg}={s['SubnetId']} \\")

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--cluster-profile", required=True, help="AWS profile owning the MSK cluster"
    )
    parser.add_argument(
        "--function-profile", required=True, help="AWS profile owning the Lambda function"
    )
    parser.add_argument("--region", default="us-east-1", help="both accounts must share it.")
    parser.add_argument(
        "--azs", type=int,
        default=DEFAULT_AZS,
        help="subnets per side; must divide NumberOfBrokerNodes in MSK/template.yml"
    )
    parser.add_argument(
        "--top", type=int, default=3, help="how many of the ranked combinations to print; raise it to see them all"
    )
    args = parser.parse_args()
    if args.cluster_profile == args.function_profile:
        sys.exit("cluster and function profiles must differ for a cross-account test")
    cluster = survey(args.cluster_profile, args.region)
    function = survey(args.function_profile, args.region)
    results = combinations(cluster, function, args.azs)
    if not results:
        sys.exit(
            f"No VPC pair shares {args.azs} AZ IDs between "
            f"{cluster['Account']} and {function['Account']} in {args.region}."
        )

    print(
        f"{len(results)} combination(s) in {args.region}; "
        f"showing top {min(args.top, len(results))}"
    )

    for rank, result in enumerate(results[: args.top], start=1):
        print(f"\n--- #{rank} ---")
        report(result, cluster, function, args.azs)

if __name__ == "__main__":
    main()
