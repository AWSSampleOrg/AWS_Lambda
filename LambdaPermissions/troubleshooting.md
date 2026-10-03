# How do I resolve Lambda function "KMS Exception" permission errors?

Error occurs when using default AWS managed KMS key which is `aws/lambda` to encrypt/decrypt environment variables. When you create a function, change IAM role or change default key - Lambda service adds a grant to the key.

However the following error occurs when a Lambda function's execution role is deleted and then recreated with the same name but with a different principal:

```
Calling the invoke API action failed with this message: Lambda was unable to decrypt the environment variables because KMS access was denied. Please check the function's AWS KMS key settings. KMS Exception: UnrecognizedClientExceptionKMS Message: The security token included in the request is invalid
```

- How do I resolve Lambda function "KMS Exception" permission errors?

  https://repost.aws/knowledge-center/lambda-kmsaccessdeniedexception-errors
