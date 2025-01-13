## Errors

If your function code caused the error, **`Lambda will stop processing and retrying the invocation.`** In the meantime, Lambda gradually backs off, reducing the amount of concurrency allocated to your Amazon SQS event source mapping. **`After your queue's visibility timeout runs out, the message will again reappear in the queue.`**

## Throttles

If the invocation fails due to throttling, Lambda gradually backs off retries by reducing the amount of concurrency allocated to your Amazon SQS event source mapping. Lambda continues to retry the message unless the message's remaining visibility timeout is less than the destination function's configured timeout.

- Handling errors for an SQS event source in Lambda
  https://docs.aws.amazon.com/lambda/latest/dg/services-sqs-errorhandling.html

| Error Type            | Actions performed by Lambda |
| --------------------- | --------------------------- |
| Throttle              | 1, 2                        |
| Non recoverable error | 1, 2, 3                     |
| Errors                | 1, 4                        |
| OK                    | 5                           |
| System Error          | 1, 2                        |

1. Back off by reducing the ESM-level concurrency
2. Lambda continues to retry the message unless the message's remaining visibility timeout is less than the destination function's configured timeout.
3. Disable the ESM. [Why did my Lambda Amazon SQS trigger get disabled?](https://repost.aws/knowledge-center/lambda-sqs-trigger)
4. Don't retry and wait until message's visibility time out, the receive message and invoke a function again.
5. Delete entire batches. If the FunctionResponseType is ReportBatchItemFailures, then delete only succeeded messages.
