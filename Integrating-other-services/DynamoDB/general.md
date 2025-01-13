# Handle the number of DynamoDB stream shards (partitions)

https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/bp-partition-key-design.html
https://aws.amazon.com/blogs/database/choosing-the-right-dynamodb-partition-key/

- The number of shards equal to the number of partitions.
- Each partitions on a DynamoDB table can handle up to 3,000 RCUs (Read capacity units), 1,000 WCUs (Write capacity units) and 10 GB data. Exceeding any of these parameters results in adding a new partition to the table and creating a new shard in the DynamoDB stream.
