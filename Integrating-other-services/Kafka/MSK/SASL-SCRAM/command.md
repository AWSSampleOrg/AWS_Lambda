https://docs.aws.amazon.com/lambda/latest/dg/with-msk.html

Download Kafka CLI like `kafka-topics.sh`.

Search target version's tgz file under https://archive.apache.org/dist/kafka/

```sh
wget https://archive.apache.org/dist/kafka/3.6.0/kafka_2.13-3.6.0.tgz
tar -xzf kafka_2.13-3.6.0.tgz
```

# Get connection strings

## Bootstrap servers

- aws kafka get-bootstrap-brokers
  https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kafka/get-bootstrap-brokers.html#output

```
BootstrapBrokerString -> (string)
    A string containing one or more hostname:port pairs.
BootstrapBrokerStringTls -> (string)
    A string containing one or more DNS names (or IP) and TLS port pairs.
BootstrapBrokerStringSaslScram -> (string)
    A string containing one or more DNS names (or IP) and Sasl Scram port pairs.
BootstrapBrokerStringSaslIam -> (string)
    A string that contains one or more DNS names (or IP addresses) and SASL IAM port pairs.
BootstrapBrokerStringPublicTls -> (string)
    A string containing one or more DNS names (or IP) and TLS port pairs.
BootstrapBrokerStringPublicSaslScram -> (string)
    A string containing one or more DNS names (or IP) and Sasl Scram port pairs.
BootstrapBrokerStringPublicSaslIam -> (string)
    A string that contains one or more DNS names (or IP addresses) and SASL IAM port pairs.
BootstrapBrokerStringVpcConnectivityTls -> (string)
    A string containing one or more DNS names (or IP) and TLS port pairs for VPC connectivity.
BootstrapBrokerStringVpcConnectivitySaslScram -> (string)
    A string containing one or more DNS names (or IP) and SASL/SCRAM port pairs for VPC connectivity.
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

https://docs.aws.amazon.com/msk/latest/developerguide/create-topic.html

```sh
CLUSTER_ARN=""

BS=$(aws kafka get-bootstrap-brokers --cluster-arn ${CLUSTER_ARN} --query BootstrapBrokerStringSaslIam --output text)
./bin/kafka-topics.sh --bootstrap-server $BS --describe --topic ExampleTopic10
```

# Produce and consume

Producer

```sh
CLUSTER_ARN=""

BS=$(aws kafka get-bootstrap-brokers --cluster-arn ${CLUSTER_ARN} --query BootstrapBrokerStringSaslIam --output text)
bin/kafka-console-producer.sh --broker-list $BS --producer.config ./config/client.properties --topic AWSKafkaTutorialTopic
```

Consumer

```sh
CLUSTER_ARN=""

BS=$(aws kafka get-bootstrap-brokers --cluster-arn ${CLUSTER_ARN} --query BootstrapBrokerStringSaslIam --output text)
bin/kafka-console-consumer.sh --bootstrap-server $BS --consumer.config ./config/client.properties --topic AWSKafkaTutorialTopic --from-beginning
```
