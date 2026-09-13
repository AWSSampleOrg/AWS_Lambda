#!/usr/bin/env bash
STACK_NAME="Lambda-with-Kafka-Cross-Account"
PROFILE=""

SOURCE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}) && pwd)
cd ${SOURCE_DIR}


# https://docs.aws.amazon.com/msk/latest/developerguide/mvpc-cluster-owner-action-turn-on.html
# "The MSK cluster owner needs to make configuration settings on the MSK cluster after the cluster is created and in an ACTIVE state."
# So enable this after the MSK cluster is created.
params=('false' 'true')
for vpc_connectivity_iam in ${params[@]} ; do
    aws cloudformation deploy \
        --template-file template.yml \
        --stack-name ${STACK_NAME} \
        --parameter-overrides \
        FunctionAccountId= \
        VpcId= \
        PrivateSubnetAId= \
        PrivateSubnetCId= \
        VpcConnectivityIam=${vpc_connectivity_iam} \
        --capabilities CAPABILITY_NAMED_IAM \
        --profile ${PROFILE}

    CLUSTER_ARN=$(aws cloudformation describe-stacks \
        --stack-name ${STACK_NAME} \
        --profile ${PROFILE} \
        --query "Stacks[0].Outputs[?OutputKey=='ClusterArn'].OutputValue" \
        --output text)

    # CREATE_COMPLETE does not guarantee the cluster reached ACTIVE, and
    # UpdateConnectivity is rejected unless it is. Wait before the next pass.
    until [ "$(aws kafka describe-cluster-v2 \
        --cluster-arn ${CLUSTER_ARN} \
        --query ClusterInfo.State \
        --output text \
        --profile ${PROFILE})" = "ACTIVE" ] ; do
        echo "waiting for ACTIVE ..." ; sleep 60
    done
done

echo "ClusterArn: ${CLUSTER_ARN}"

aws kafka get-bootstrap-brokers --cluster-arn ${CLUSTER_ARN} --profile ${PROFILE}
