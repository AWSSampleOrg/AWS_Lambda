# Overview

https://docs.aws.amazon.com/lambda/latest/dg/with-msk.html

## Network Configuration

- VPC associated with your Kafka cluster includes one NAT Gateway per public subnet.
  Or
- VPC endpoints for Lambda, AWS STS and Secrets Manager, if SASL/mTLS auth is enabled.

## Security Group Configuration

- Inbound rules
  - All traffic on MSK broker port 9092 for plaintext, 9094 for TLS, 9096 for SASL, 9098 for IAM for the Security group mentioned in your event source.
- Outbound rules
  - Allow all traffic on port 443 for all destinations. Allow all traffic on MSK broker port (9092 for plaintext, 9094 for TLS, 9096 for SASL, 9097 for IAM).
  - VPC endpoints must allow all inbound traffic on port 443 from the event source's security groups.
