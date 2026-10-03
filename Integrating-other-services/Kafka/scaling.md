# Scaling

### maximum concurrency = total number of partitions with records in the Kafka topic.

### On-demand mode (default)

In one-minute intervals, Lambda evaluates the offset lag of all the partitions in the topic. If the offset lag is too high, the partition is receiving messages faster than Lambda can process them. If necessary, Lambda adds or removes event pollers from the topic. This autoscaling process of adding or removing event pollers occurs within three minutes of evaluation.

### Provisioned mode

In provisioned mode, you define minimum and maximum limits for the amount of provisioned event pollers. These provisioned event pollers are dedicated to your event source mapping, and can handle unexpected message spikes through responsive autoscaling. We recommend that you use provisioned mode for Kafka workloads that have strict performance requirements.

In Lambda, an event poller is a compute unit capable of handling up to 5 MBps of throughput. For reference, suppose your event source produces an average payload of 1MB, and the average function duration is 1 sec. If the payload doesn’t undergo any transformation (such as filtering), a single poller can support 5 MBps throughput, and 5 concurrent Lambda invocations. Using provisioned mode incurs additional costs
