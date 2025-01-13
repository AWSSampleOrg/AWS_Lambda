## 1. Initialization code is run more frequently than the total number of invocations.

Since Lambda is highly available, for every one unit of Provisioned Concurrency, there are a minimum of two execution environments prepared in separate Availability Zones.

- Operating Lambda: Performance optimization – Part 1
  https://aws.amazon.com/blogs/compute/operating-lambda-performance-optimization-part-1/

  ```
  Initialization code is run more frequently than the total number of invocations. Since Lambda is highly available, for every one unit of Provisioned Concurrency, there are a minimum of two execution environments prepared in separate Availability Zones. This is to ensure that your code is available in the event of a service disruption. As environments are reaped and load balancing occurs, Lambda over-provisions environments to ensure availability. You are not charged for this activity. If your code initializer implements logging, you will see additional log files anytime that this code is run, even though the main handler is not invoked.
  ```

## 2. When you set Provisioned Concurrency, You'll have less unreserved concurrency available.

So both `reserved concurrency` and `provisioned concurrency` contribute to decreasing the unreserved concurrency in your account.

- https://docs.aws.amazon.com/lambda/latest/dg/provisioned-concurrency.html#configuring-provisioned-concurrency
  ```
  Configuring provisioned concurrency for a function has an impact on the concurrency pool available to other functions. For instance, if you configure 100 units of provisioned concurrency for function-a, other functions in your account must share the remaining 900 units of concurrency. This is true even if function-a doesn't use all 100 units.
  ```

## 3. You can't allocate more `provisioned concurrency` than `reserved concurrency` for a Lambda function.

For example, it's OK below.

- Reserved concurrency
  10
- Version 1
  Provisioned concurrency 3
- Version 2
  Provisioned concurrency 3
- Version 3
  Provisioned concurrency 4

But it's not OK below. Because the total of provisioned concurrency exceeds the number of reserved concurrency.

- Reserved concurrency
  10
- Version 1
  Provisioned concurrency 3
- Version 2
  Provisioned concurrency 3
- Version 3
  Provisioned concurrency 5

## 4. Function with provisioned concurrency have a maximum rate of 10 requests per second per provisioned concurrency. For example, a function configured with 100 provisioned concurrency can handle 1,000 requests per second. If the invocation rate exceeds 1,000 requests per second, some cold starts can occur.

https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html#api-requests

```
Invocation requests per function version or alias (requests per second)

10 x allocated provisioned concurrency
Note

This quota applies only to functions that use provisioned concurrency.
```

## 5. Provisioned concurrency can't be configured on `weighted alias`.
