[Using an Amazon MSK cluster as an event source](https://docs.aws.amazon.com/lambda/latest/dg/with-msk-configure.html)

- Lambda reads messages sequentially for each Kafka topic partition.
- A single Lambda payload can contain messages from multiple partitions but that's only occurs when concurrency is less than number of partitions.
  When more records are available, Lambda continues processing records in batches, based on the BatchSize value that you specify in a CreateEventSourceMapping request, until your function catches up with the topic.
