## 1. Find available combinations of subnets.

```sh
python find_subnets.py --cluster-profile '' --function-profile '' --region us-east-1 --top 30
```

Replace `./MSK/deploy.sh` and `./Lambda/deploy.sh` with one of the combinations you got from above command.

usage

```sh
python find_subnets.py  --help
```

## 2. Deploy a MSK cluster

```sh
./MSK/deploy.sh
```

## 3. Create a topic in the MSK cluster

See ./MSK/command.md for the CLI setup.

## 4. Deploy a Lambda function and ESM.

```sh
./Lambda/deploy.sh
```
