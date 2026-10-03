### 1. With Amazon SQS event source mappings, Lambda polls the queue and invokes your function synchronously with an event.

https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html

### 2. The maximum batch size for a standard Amazon SQS queue is `10,000` records. For FIFO queues, the maximum batch size is `10` records.

### 3. Lambda invokes your function when one of the following three criteria is met

- The batching window reaches its maximum value.
  - For Kinesis, DynamoDB, and Amazon SQS event sources: The default batching window is `0 seconds`.
  - For Amazon MSK, self-managed Apache Kafka, Amazon MQ, and Amazon DocumentDB event sources: The default batching window is `500 ms`.
- The batch size is met. The default and maximum batch size `depend on the event source`.
- The payload size reaches `6 MB`. You cannot modify this limit.

Plus

Incoming messages contribute to the number of messages that each payload has.

### 4. If you're using a batch window and your SQS queue contains very low traffic, Lambda might wait for up to `20 seconds` before invoking your function. This is true even if you set a batch window lower than 20 seconds.

[Lambda / Using Lambda with Amazon SQS](https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html)

### 5. Short poll is the default behavior where a weighted random set of machines is sampled on a ReceiveMessage call. Therefore, only the messages on the sampled machines are returned. `If the number of messages in the queue is small (fewer than 1,000), you most likely get fewer messages than you requested per ReceiveMessage call.`

https://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_ReceiveMessage.html

### 6. A maxReceiveCount of at least five, visibility time out should be at least six times the function timeout.

https://repost.aws/knowledge-center/lambda-retrying-valid-sqs-messages

```
A maxReceiveCount of at least five gives your messages more chances to be processed before they're sent to your dead-letter queue.
```

```
Set your source queue's visibility timeout to at least six times longer than your function's timeout.
```
