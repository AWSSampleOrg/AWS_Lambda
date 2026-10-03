https://docs.aws.amazon.com/lambda/latest/dg/with-msk.html

Download Kafka CLI like `kafka-topics.sh`.

Search target version's tgz file under https://archive.apache.org/dist/kafka/

```sh
wget https://archive.apache.org/dist/kafka/3.9.0/kafka_2.13-3.9.0.tgz
tar -xzf kafka_2.13-3.9.0.tgz
# If you use IAM auth
# https://github.com/aws/aws-msk-iam-auth/releases
cd kafka_2.13-3.9.0/libs
wget https://github.com/aws/aws-msk-iam-auth/releases/download/v2.3.8/aws-msk-iam-auth-2.3.8-all.jar
cd ..
```

# Client configuration for IAM auth

```sh
cat > ./config/client.properties << 'EOF'
security.protocol=SASL_SSL
sasl.mechanism=AWS_MSK_IAM
sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required;
sasl.client.callback.handler.class=software.amazon.msk.auth.iam.IAMClientCallbackHandler
EOF
```

`ssl.truststore.location` is omitted on purpose: "When you don't specify a value for `ssl.truststore.location`, the Java process uses default certificate."
To pick a named profile instead of the default credentials, append `awsProfileName="<profile>";` to the `sasl.jaas.config` line.

# Get connection strings

## Bootstrap servers

- aws kafka get-bootstrap-brokers
  https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kafka/get-bootstrap-brokers.html#output

```
BootstrapBrokerStringSaslIam -> (string)
    A string that contains one or more DNS names (or IP addresses) and SASL IAM port pairs.
BootstrapBrokerStringPublicSaslIam -> (string)
    A string that contains one or more DNS names (or IP addresses) and SASL IAM port pairs.
BootstrapBrokerStringVpcConnectivitySaslIam -> (string)
    A string containing one or more DNS names (or IP) and SASL/IAM port pairs for VPC connectivity.
```

```sh
CLUSTER_ARN=""
# Bootstrap Broker
aws kafka get-bootstrap-brokers --cluster-arn ${CLUSTER_ARN}
# ZooKeeper
aws kafka describe-cluster-v2 --cluster-arn ${CLUSTER_ARN} --query ClusterInfo
```

# Create topics

## With AWS CLI

```sh
aws kafka create-topic --cluster-arn ${CLUSTER_ARN} --topic-name MSKTutorialTopic --partition-count 2 --replication-factor 2
# Show configs
aws kafka describe-topic --cluster-arn ${CLUSTER_ARN} --topic-name MSKTutorialTopic --query Configs --output text | base64 -d | jq -r .
```

## With the Kafka CLI

https://docs.aws.amazon.com/msk/latest/developerguide/create-topic.html

```sh
CLUSTER_ARN=""

BS=$(aws kafka get-bootstrap-brokers --cluster-arn ${CLUSTER_ARN} --query BootstrapBrokerStringSaslIam --output text)

./bin/kafka-topics.sh --create --bootstrap-server $BS --command-config ./config/client.properties --replication-factor 2 --partitions 2 --topic MSKTutorialTopic
./bin/kafka-topics.sh --bootstrap-server $BS --describe --topic MSKTutorialTopic --command-config ./config/client.properties
```

# Produce and consume

Producer

```sh
CLUSTER_ARN=""

BS=$(aws kafka get-bootstrap-brokers --cluster-arn ${CLUSTER_ARN} --query BootstrapBrokerStringSaslIam --output text)
bin/kafka-console-producer.sh --broker-list $BS --producer.config ./config/client.properties --topic MSKTutorialTopic
```

Consumer

```sh
CLUSTER_ARN=""

BS=$(aws kafka get-bootstrap-brokers --cluster-arn ${CLUSTER_ARN} --query BootstrapBrokerStringSaslIam --output text)
bin/kafka-console-consumer.sh --bootstrap-server $BS --consumer.config ./config/client.properties --topic MSKTutorialTopic --from-beginning
```
