# Execution Environments

[Lambda execution environment](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtime-environment.html)

![Lambda execution environment lifecycle](https://docs.aws.amazon.com/images/lambda/latest/dg/images/Overview-Successful-Invokes.png)

1. Init phase
   - Start all extensions (Extension init)
   - Bootstrap the runtime (Runtime init)
   - Run the function's static code (Function init)
   - Run any beforeCheckpoint runtime hooks (Lambda SnapStart only)
