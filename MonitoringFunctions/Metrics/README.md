# When is a metric recorded ?

https://docs.aws.amazon.com/lambda/latest/dg/monitoring-metrics-view.html

```
The timestamp on a metric reflects when the function was invoked. Depending on the duration of the invocation, this can be several minutes before the metric is emitted. For example, if your function has a 10-minute timeout, then look more than 10 minutes in the past for accurate metrics.
```

# Types of metrics

https://docs.aws.amazon.com/lambda/latest/dg/monitoring-metrics-types.html

## If an invocations is throttled.

`Throttles` is marked greater than 0, `Errors` is marked as 0.
