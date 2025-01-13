# Throttled reason. Status code 429

```
Concurrency = (average requests per second) * (average request duration in seconds)
```

1. Invocations more than an account level concurrency limit.

- https://docs.aws.amazon.com/lambda/latest/dg/lambda-concurrency.html#reserved-and-provisioned
  ```
  At the account level, your functions can have up to 1,000 units of concurrency by default. To increase this limit, see Requesting a quota increase in the Service Quotas User Guide.
  ```

2. Increasing invocation rate faster than the scaling limit allows.

[AWS Lambda functions now scale 12 times faster when handling high-volume requests](https://aws.amazon.com/blogs/aws/aws-lambda-functions-now-scale-12-times-faster-when-handling-high-volume-requests/)

3. Using reserved concurrency and invoked more than an customer reserved concurrency for that function allows.

- https://docs.aws.amazon.com/lambda/latest/dg/lambda-concurrency.html#reserved-and-provisioned
  ```
  At the function level, you can reserve up to 900 units of concurrency across all your functions by default. Regardless of your total account concurrency limit, Lambda always reserves 100 units of concurrency for your functions that don't explicitly reserve concurrency. For example, if you increased your account concurrency limit to 2,000, then you can reserve up to 1,900 units of concurrency at the function level.
  ```

4. For `synchronous` invocations, each instance of your execution environment can serve up to 10 requests per second. In other words, the total invocation limit is 10 times your concurrency limit.

- [Lambda API](https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html#api-requests)

  ```
  Invocation requests per function per Region (synchronous)

  Each instance of your execution environment can serve up to 10 requests per second. In other words, the total invocation limit is 10 times your concurrency limit. See Understanding Lambda function scaling.
  ```

# Concurrency

- [Understanding concurrency and requests per second](https://docs.aws.amazon.com/lambda/latest/dg/lambda-concurrency.html#concurrency-vs-requests-per-second)

| Resource                                                                | Resource                                                                                                                                                                                                                              |
| ----------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Invocation requests per function per Region (synchronous)               | Each instance of your execution environment can serve up to 10 requests per second. In other words, the total invocation limit is 10 times your concurrency limit. See Understanding Lambda function scaling.                         |
| Invocation requests per function per Region (asynchronous)              | Each instance of your execution environment can serve an unlimited number of requests. In other words, the total invocation limit is based only on concurrency available to your function. See Understanding Lambda function scaling. |
| Invocation requests per function version or alias (requests per second) | 10 x allocated provisioned concurrency. Note: This quota applies only to functions that use provisioned concurrency.                                                                                                                  |

1. 10 x allocated provisioned concurrency. Note: This quota applies only to functions that use provisioned concurrency.

Functions with provisioned concurrency have a maximum rate of 10 requests per second per provisioned concurrency, For example, a function configured with 100 provisioned concurrency can handle 1,000 requests oer second. If the invocation rate exceeds 1,000 requests per second, the remaining invocations will be spilled over to on-demand.
