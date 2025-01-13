endpoint=''

AWS_REGION=$(aws configure get region)
AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)

curl -w '\n\n' \
    -v \
    $endpoint
# 403 {"message":"Missing Authentication Token"}

curl -w '\n\n' \
    -v \
    --aws-sigv4 "aws:amz:${AWS_REGION}:lambda" \
    --user AccessKey:SecretKey \
    $endpoint
# 403 {"message":"The security token included in the request is invalid."}

curl -w '\n' \
    -v \
    --aws-sigv4 "aws:amz:${AWS_REGION}:lambda" \
    --user ${AWS_ACCESS_KEY_ID}:${AWS_SECRET_ACCESS_KEY} \
    $endpoint
# 200 {"message": "OK"}
