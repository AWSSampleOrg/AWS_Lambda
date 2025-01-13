# Identify if the retries were made by AWS Lambda or event source.

- If the request ID of retried invocation is `same` as the one of first invocation, it was retried by the `Lambda service`.
- If the request ID of retried invocation is `different` from the one of first invocation, it was retried by the `event source` such as EventBridge, S3.

# If the request ID is same, which means it was retried by AWS Lambda.

| Result            | Retry Behavior                                          | Controlling Parameter    |
| ----------------- | ------------------------------------------------------- | ------------------------ |
| Success           | No Retry (But could be possible to reinvoke again)      | N/A                      |
| Application Error | Retries 2 times by default                              | MaximumRetryAttempts     |
|                   | `one-minute` wait between the first two attempts,       |                          |
|                   | and `two minutes` between the second and third attempts |                          |
| Throttle          | Retries up to 6 hours by default                        | MaximumEventAgeInSeconds |
| System Error      | Retries up to 6 hours by default                        | MaximumEventAgeInSeconds |

- How Lambda handles errors and retries with asynchronous invocation
  https://docs.aws.amazon.com/lambda/latest/dg/invocation-async-error-handling.html
  ```
  Lambda manages your function's asynchronous event queue and attempts to retry on errors. If the function returns an error, by default Lambda attempts to run it two more times, with a one-minute wait between the first two attempts, and two minutes between the second and third attempts. Function errors include errors returned by the function's code and errors returned by the function's runtime, such as timeouts.
  .
  .
  .
  If the function doesn't have enough concurrency available to process all events, additional requests are throttled. For throttling errors (429) and system errors (500-series), Lambda returns the event to the queue and attempts to run the function again for up to 6 hours by default.
  .
  .
  .
  Even if your function doesn't return an error, it's possible for it to receive the same event from Lambda multiple times because the queue itself is eventually consistent.
  ```
