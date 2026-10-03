# [Deploying Lambda functions](https://docs.aws.amazon.com/lambda/latest/dg/lambda-deploy-functions.html)

[Optimizing Lambda functions packaged as container images](https://aws.amazon.com/blogs/compute/optimizing-lambda-functions-packaged-as-container-images/)

```
First, the AWS-provided base images are cached pro-actively by the Lambda service. This means that the base image is either nearby in another upstream cache or already in the worker instance cache. Despite being much larger, the deployment time may still be shorter when compared to third-party base images, which may not be cached.
```

[re:Invent 2021 talk Deep dive into AWS Lambda security: Function isolation.](https://d1.awsstatic.com/events/reinvent/2020/Deep_dive_into_AWS_Lambda_security_Function_isolation_SVS404.pdf)
