https://docs.aws.amazon.com/lambda/latest/dg/with-msk.html

Download Kafka CLI like `kafka-topics.sh`.

Search target version's tgz file under https://archive.apache.org/dist/kafka/

```sh
wget https://archive.apache.org/dist/kafka/4.0.0/kafka_2.13-4.0.0.tgz
tar -xzf kafka_2.13-4.0.0.tgz
```

# Get connection strings

### Bootstrap servers

```sh
aws kafka get-bootstrap-brokers --cluster-arn <Cluster ARN> --query BootstrapBrokerString --output text
aws kafka get-bootstrap-brokers --cluster-arn <Cluster ARN> --query BootstrapBrokerStringTls --output text
```

### Apache ZooKeeper

```sh
aws kafka describe-cluster-v2 --cluster-arn '' --query ClusterInfo.Provisioned.ZookeeperConnectString
aws kafka describe-cluster-v2 --cluster-arn '' --query ClusterInfo.Provisioned.ZookeeperConnectStringTls
```

# Create topics

```sh
BS=$(aws kafka get-bootstrap-brokers --cluster-arn <Cluster ARN> --query BootstrapBrokerStringTls --output text)
./bin/kafka-topics.sh --bootstrap-server $BS --describe --topic ExampleTopic10
```

# Produce and consume

Producer

```sh
BS=$(aws kafka get-bootstrap-brokers --cluster-arn <Cluster ARN> --query BootstrapBrokerStringTls --output text)
bin/kafka-console-producer.sh --broker-list $BS --producer.config client.properties --topic AWSKafkaTutorialTopic
```

Consumer

```sh
BS=$(aws kafka get-bootstrap-brokers --cluster-arn <Cluster ARN> --query BootstrapBrokerStringTls --output text)
bin/kafka-console-consumer.sh --bootstrap-server $BS --consumer.config client.properties --topic AWSKafkaTutorialTopic --from-beginning
```
