## [Why is my Lambda function retrying valid Amazon SQS messages and placing them in my dead-letter queue?](https://repost.aws/knowledge-center/lambda-retrying-valid-sqs-messages)

- Verify that your Lambda function's code is idempotent
- Verify that your Amazon SQS queue's visibility timeout is at least six times longer than your Lambda function's timeout setting
- Verify that the maxReceiveCount attribute is set to at least five on your source queue's redrive policy
- Check the Lambda function for throttling and reserved concurrency
- Avoid reprocessing all SQS messages in a failed batch.
  To avoid reprocessing all SQS messages in a failed batch, configure your event source mapping with the value ReportBatchItemFailures in the FunctionResponseTypes list.
- Identify and resolve any errors that your Lambda function returns

## [Why did my Lambda Amazon SQS trigger get disabled?](https://repost.aws/knowledge-center/lambda-sqs-trigger)

Lambda pollers constantly make the ReceiveMessage API action call to the Amazon SQS queue. If the ReceiveMessage API call doesn't complete, then the EventSourceMapping resource is disabled.

- Make sure that your Lambda function execution role has access to the following permissions:
  - ChangeMessageVisibility
  - DeleteMessage
  - GetQueueAttributes
  - ReceiveMessage
- AWS Key Management Service (AWS KMS) permissions If the Amazon SQS queue is configured with SSE-KMS encryption.

## [Why isn't my Lambda function that's configured with SQS as the event source invoked?](https://repost.aws/knowledge-center/lambda-sqs-event-source)

- Check that the Lambda function and SQS queue URLs are correct
- Check the Lambda function permissions
- Check the encryption settings for the queue
- Check if the specific Lambda function is throttled
- Confirm that there are no other active consumers on the same SQS queue
- Check if the SQS event source is configured with filters
