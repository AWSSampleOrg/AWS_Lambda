https://docs.aws.amazon.com/lambda/latest/dg/with-msk.html

Download Kafka CLI like `kafka-topics.sh`.

Search target version's tgz file under https://archive.apache.org/dist/kafka/

```sh
wget https://archive.apache.org/dist/kafka/3.9.0/kafka_2.13-3.9.0.tgz
tar -xzf kafka_2.13-3.9.0.tgz
```

# Client configuration

```sh
SECRET_ID='AmazonMSK_LambdaEsm'
SCRAM_USERNAME=$(aws secretsmanager get-secret-value --secret-id ${SECRET_ID} --query SecretString --output text | jq -r .username)
SCRAM_PASSWORD=$(aws secretsmanager get-secret-value --secret-id ${SECRET_ID} --query SecretString --output text | jq -r .password)

cat > ./config/client.properties << EOF
security.protocol=SASL_SSL
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username="${SCRAM_USERNAME}" password="${SCRAM_PASSWORD}";
EOF
```

# Get connection strings

## Bootstrap servers

- aws kafka get-bootstrap-brokers
  https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kafka/get-bootstrap-brokers.html#output

```
BootstrapBrokerStringSaslScram -> (string)
    A string containing one or more DNS names (or IP) and Sasl Scram port pairs.
BootstrapBrokerStringPublicSaslScram -> (string)
    A string containing one or more DNS names (or IP) and Sasl Scram port pairs.
BootstrapBrokerStringVpcConnectivitySaslScram -> (string)
    A string containing one or more DNS names (or IP) and SASL/SCRAM port pairs for VPC connectivity.
```

```sh
STACK_NAME="Lambda-with-Kafka-SCRAM"
CLUSTER_ARN=$(
    aws cloudformation describe-stacks \
        --stack-name ${STACK_NAME} \
        --query "Stacks[0].Outputs[?OutputKey=='MSKClusterArn'].OutputValue" \
        --output text
)
# Bootstrap Broker
aws kafka get-bootstrap-brokers --cluster-arn ${CLUSTER_ARN}
aws kafka list-scram-secrets --cluster-arn ${CLUSTER_ARN}
BS=$(aws kafka get-bootstrap-brokers --cluster-arn ${CLUSTER_ARN} --query BootstrapBrokerStringSaslScram --output text)
```

# Produce and consume

Producer

```sh
bin/kafka-console-producer.sh --broker-list $BS --producer.config ./config/client.properties --topic MSKTutorialTopic
```
