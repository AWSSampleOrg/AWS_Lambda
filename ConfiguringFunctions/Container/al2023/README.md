# [AWS OS-only base image](https://docs.aws.amazon.com/lambda/latest/dg/images-create.html#runtimes-images-provided)

## [public.ecr.aws/lambda/provided:al2023](https://gallery.ecr.aws/lambda/provided)

What is configured in Dockerfile by default?

```Dockerfile
FROM public.ecr.aws/lambda/provided:al2023

RUN pwd
# /var/task

RUN env | sort
# HOME=/root
# LAMBDA_RUNTIME_DIR=/var/runtime
# LAMBDA_TASK_ROOT=/var/task
# LANG=en_US.UTF-8
# LD_LIBRARY_PATH=/var/lang/lib:/lib64:/usr/lib64:/var/runtime:/var/runtime/lib:/var/task:/var/task/lib:/opt/lib
# PATH=/var/lang/bin:/usr/local/bin:/usr/bin/:/bin:/opt/bin
# PWD=/var/task
# SHLVL=1
# TZ=:/etc/localtime
# _=/usr/bin/env
```
