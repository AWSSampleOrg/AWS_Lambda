# When is a metric recorded ?

https://docs.aws.amazon.com/lambda/latest/dg/monitoring-metrics-view.html

```
The timestamp on a metric reflects when the function was invoked. Depending on the duration of the invocation, this can be several minutes before the metric is emitted. For example, if your function has a 10-minute timeout, then look more than 10 minutes in the past for accurate metrics.
```

# Types of metrics

## [Invocation metrics](https://docs.aws.amazon.com/lambda/latest/dg/monitoring-metrics-types.html#invocation-metrics)

- If an invocations is throttled.

  `Throttles` is marked greater than 0, `Errors` is marked as 0.

- If a Lambda function's state is `inactive`, `Invocations` metric are not recorded, but `Errors` metric should be recorded.

## [Asynchronous invocation metrics](https://docs.aws.amazon.com/lambda/latest/dg/monitoring-metrics-types.html#async-invocation-metrics)

- If a reserved concurrency is set to 0, Lambda service will never invoke your function, and invocations never get throttled.
