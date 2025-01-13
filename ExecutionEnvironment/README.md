# Execution Environments

[Lambda execution environment](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtime-environment.html)

![Lambda execution environment lifecycle](https://docs.aws.amazon.com/images/lambda/latest/dg/images/Overview-Successful-Invokes.png)

# Init phase

- Start all extensions (Extension init)
- Bootstrap the runtime (Runtime init)
- Run the function's static code (Function init)
- Run any beforeCheckpoint runtime hooks (Lambda SnapStart only)

## `INIT_START`

Lambda always emits INIT_START

## `INIT_REPORT`

If the Init phase is successful, Lambda doesn't emit the INIT_REPORT log unless SnapStart or provisioned concurrency is enabled. SnapStart and provisioned concurrency functions always emit INIT_REPORT.

## If SnapStart is enabled

- RESTORE_START
- RESTORE_REPORT

**Only the very first invocation when new environment is created.**

# Invoke phase

### Basic Logs

- `START RequestId`
- `END RequestId`
- `REPORT RequestId`

### Failure

https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtime-environment.html#runtimes-lifecycle-invoke-with-errors

time out

- Old style
- New style
