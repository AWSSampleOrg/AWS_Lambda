- Wrapper scripts are supported on all native [Lambda runtimes](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html). Wrapper scripts are not supported on [OS-only runtimes](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-provided.html) (the provided runtime family).

- Add environment variable
  - key
    AWS_LAMBDA_EXEC_WRAPPER
  - value
    /opt/importtime_wrapper
