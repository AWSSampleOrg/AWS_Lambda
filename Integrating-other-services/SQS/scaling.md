- Why isn't my Lambda function with an Amazon SQS event source optimally scaling?

  https://repost.aws/knowledge-center/lambda-sqs-scaling

- Understanding how AWS Lambda scales with Amazon SQS standard queues

  https://aws.amazon.com/blogs/compute/understanding-how-aws-lambda-scales-when-subscribed-to-amazon-sqs-queues/

# Lambda scaling for Standard Queues

[Configuring scaling behavior for SQS event source mappings](https://docs.aws.amazon.com/lambda/latest/dg/services-sqs-scaling.html)

- When messages are available, Lambda starts processing `five batches` at a time with `five concurrent` invocations of your function.
- If messages are still available, Lambda increases the number of processes that are reading batches by up to `300 more instances per minute`.
- The Scaling continues until one of the following occurs
  - Lambda concurrency reach 1,000 default account limit (It can reach up to `1,250` which can be increased.)
  - Account concurrency limit reaches
  - Reserved concurrency of the function if you configured.
  - `MaximumConcurrency` of the event source mappings.

# Lambda scaling for FIFO Queues

[Configuring scaling behavior for SQS event source mappings](https://docs.aws.amazon.com/lambda/latest/dg/services-sqs-scaling.html)

For FIFO queues, Lambda sends messages to your function in the order that it receives them. When you send a message to a FIFO queue, you specify a message group ID. Amazon SQS ensures that messages in the same group are delivered to Lambda in order. When Lambda reads your messages into batches, each batch may contain messages from more than one message group, but the order of the messages is maintained. If your function returns an error, the function attempts all retries on the affected messages before Lambda receives additional messages from the same group.

# Poller scaling for SQS queues

[Configuring scaling behavior for SQS event source mappings](https://docs.aws.amazon.com/lambda/latest/dg/services-sqs-scaling.html)

- Pollers call ReceiveMessage API, even when queues are empty.
- If SQS Queue has less or no traffic
  - When configured with maximum concurrency greater than 5, the maximum number of polling threads will remain 5.
  - When maximum concurrency is not configured, pollers scales back the processing to `five concurrent batches`, and can optimize to as few as `2 concurrent batches` to reduce the SQS calls and corresponding costs.

# SQS side

[Why isn't my Lambda function with an Amazon SQS event source optimally scaling?](https://repost.aws/knowledge-center/lambda-sqs-scaling)

1. Check `ApproximateNumberOfMessagesVisible` to confirm that there are enough messages in your Amazon SQS queue to allow your Lambda function to scale

- If the metric is low or at 0, then your function can't scale.
- If the metric is high and there are no invocation issues, then increase the `batch size` on your event notification until the `Duration` metric doesn't spike.

  Note: The maximum batch size for a standard Amazon SQS queue is `10,000` records. For FIFO queues, the maximum batch size is `10` records.

2. Check `NumberOfMessagesSent` to confirm that Amazon SQS is adding the messages to a queue

3. Check `NumberOfMessagesReceived` to confirm that the consumer is making the ReceiveMessage API call

   Note: Spikes in the `NumberOfEmptyReceives` metric show that the consumer is making the ReceiveMessage API call, but the call doesn't return a message from the queue. This issue occurs when no messages are in the queue.
