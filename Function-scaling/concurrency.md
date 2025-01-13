# Concurrency

- [Understanding concurrency and requests per second](https://docs.aws.amazon.com/lambda/latest/dg/lambda-concurrency.html#concurrency-vs-requests-per-second)

| Resource                                                                | Resource                                                                                                                                                                                                                              |
| ----------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Invocation requests per function per Region (synchronous)               | Each instance of your execution environment can serve up to 10 requests per second. In other words, the total invocation limit is 10 times your concurrency limit. See Understanding Lambda function scaling.                         |
| Invocation requests per function per Region (asynchronous)              | Each instance of your execution environment can serve an unlimited number of requests. In other words, the total invocation limit is based only on concurrency available to your function. See Understanding Lambda function scaling. |
| Invocation requests per function version or alias (requests per second) | 10 x allocated provisioned concurrency. Note: This quota applies only to functions that use provisioned concurrency.                                                                                                                  |

1. 10 x allocated provisioned concurrency. Note: This quota applies only to functions that use provisioned concurrency.

Functions with provisioned concurrency have a maximum rate of 10 requests per second per provisioned concurrency, For example, a function configured with 100 provisioned concurrency can handle 1,000 requests oer second. If the invocation rate exceeds 1,000 requests per second, the remaining invocations will be spilled over to on-demand.
