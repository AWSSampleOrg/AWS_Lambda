# IteratorAge spikes

Check below repost article

- Why is my Lambda IteratorAge metric increasing, and how do I decrease it?
  https://repost.aws/knowledge-center/lambda-iterator-age
- Why does the IteratorAgeMilliseconds value in Kinesis Data Streams continue to increase?
  https://repost.aws/knowledge-center/msaf-iteratorage-metric

1. Throttles
2. Errors
3. Duration

# 1. Has `Throttles` metric gone up around the same time iterator age started rising.

Because event records are read sequentially, a function can't progress to the next record if the current invocation is throttled. In this situation, Iterator age will increase while Lambda retries the throttled invokes.

# 2. Has `Errors` metric gone up around the same time iterator age started rising.

Until the issue is resolved, no data in the shard is processed. A single malformed record can prevent processing on an entire shard since “in order” guarantee ensures that failed batches are retried until the data record expires. This is often referred to as a **`poison pill`** event in that it prevents the rest of the system from processing data.

If your function returns an error, Lambda continuously retries the batch. The batch retries continue until the processing is successful, the maximum retry attempts is reached, or the data expires from the stream.

- Identify the error from logs and fix it.
  As we learn above, Lambda poller keeps retrying the whole batch when an error occurs, so you need to use try/catch statement in a function code, and finish invocations successfully. Send the failed records to SQS, SNS or whatever to retry later on.
- Use `BisectBatchOnFunctionError` or `ReportBatchItemFailures`
- Reduce `MaximumRetryAttempts` if you do not wanna keep on retrying on the error until expiry or success and configure on failure destination to send failed records.

# 3. Has `Duration` metric gone up around the same time iterator age started rising.

### Lambda side

- If you deleted/re-created or Disabled and enabled ESM (event source mapping).
  starting position is very important in this case.
- Lambda is not getting enough records in batch
  If your function's runtime duration is independent from the number of records in an event, then increasing your function's `batch size` and `batch window` decreases the iterator age.
- If memory usage is high
  Increase the amount of memory allocated to the function. Lambda allocates CPU power in proportion to the memory.
- Use Parallelization factor
- Unequal distribution of records in shards.
  An increase in traffic to your stream with records containing the same partition key causes a shard to receive a disproportionate number of records. This results in a hot shard.

  - Under the hood: Scaling your Kinesis data streams

    https://aws.amazon.com/blogs/big-data/under-the-hood-scaling-your-kinesis-data-streams/

    ```
    If the producers write to a single shard at a rate higher than 1 MB per second or 1,000 records per second, that shard becomes a hot shard and requests exceeding that capacity get throttled, leading to a delay in leaderboard updates.
    ```

- Record size is too high
  manage it up to 6 MB.

- Optimize your function code so that less time is needed to process records.

### Kinesis Data Stream side

- Increase Shard counts of Kinesis Data Stream
  Increasing the number of shards in a stream increases the number of concurrent Lambda functions consuming from your stream, which decreases a function's iterator age.
  Note: Shard splitting doesn't have an immediate effect on a function's iterator age. Existing records remain in the shards that they were written to. Those shards must catch up on their backlog before the iterator age for the shards decreases.

- If there are other stream consumers and they're conflicting the read throughput.
  Use [Enhanced fan-out](https://docs.aws.amazon.com/streams/latest/dev/enhanced-consumers.html).
  This feature lets consumers receive records from a stream with throughput of up to 2 MB of data per second per shard. This throughput is dedicated, which means that consumers that use enhanced fan-out don't have to contend with other consumers that are receiving data from the stream.
  Stream consumers get a dedicated connection to each shard that doesn't impact other applications that are also reading from the stream.
