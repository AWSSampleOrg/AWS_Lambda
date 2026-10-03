endpoint=''

AWS_REGION=$(aws configure get region)
AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)

curl -w '\n\n' \
    -v \
    $endpoint

# < HTTP/1.1 403 Forbidden
# < Date: Sun, 22 Jun 2025 21:30:18 GMT
# < Content-Type: application/json
# < Content-Length: 23
# < Connection: keep-alive
# < x-amzn-RequestId: 6162fa5c-41bb-4d40-afe2-3ea19704fa00
# < x-amzn-ErrorType: AccessDeniedException
# <
# * Connection #0 to host xxx
# {"Message":"Forbidden"}

curl -w '\n\n' \
    -v \
    --aws-sigv4 "aws:amz:${AWS_REGION}:lambda" \
    --user AccessKey:SecretKey \
    $endpoint

# < HTTP/1.1 403 Forbidden
# < Date: Sun, 22 Jun 2025 21:21:28 GMT
# < Content-Type: application/json
# < Content-Length: 192
# < Connection: keep-alive
# < x-amzn-RequestId: e5e19476-9051-4263-9803-3c89ea8d8eba
# < x-amzn-ErrorType: InvalidSignatureException
# <
# * Connection #0 to host xxx
# {"message":"The security token included in the request is invalid."}

curl -w '\n\n' \
    -v \
    --aws-sigv4 "aws:amz:${AWS_REGION}:lambda" \
    --user ${AWS_ACCESS_KEY_ID}:${AWS_SECRET_ACCESS_KEY}x \
    $endpoint

# < HTTP/1.1 403 Forbidden
# < Date: Sun, 22 Jun 2025 21:31:25 GMT
# < Content-Type: application/json
# < Content-Length: 192
# < Connection: keep-alive
# < x-amzn-RequestId: ca8b1d9c-67cf-45db-b7bb-f37da77d91e3
# < x-amzn-ErrorType: InvalidSignatureException
# <
# * Connection #0 to host xxx
# {"message":"The request signature we calculated does not match the signature you provided. Check your AWS Secret Access Key and signing method. Consult the service documentation for details."}

curl -w '\n' \
    -v \
    --aws-sigv4 "aws:amz:${AWS_REGION}:lambda" \
    --user ${AWS_ACCESS_KEY_ID}:${AWS_SECRET_ACCESS_KEY} \
    $endpoint

# < HTTP/1.1 200 OK
# < Date: Sun, 22 Jun 2025 21:31:54 GMT
# < Content-Type: application/json
# < Content-Length: 16
# < Connection: keep-alive
# < x-amzn-RequestId: 0d7b65f1-7ff2-4965-8242-919e6634d137
# < X-Amzn-Trace-Id: Root=1-6858764a-5c96ac04102925a7698c3690;Parent=77eb47fb7ef089fe;Sampled=0;Lineage=1:23e64a83:0
# <
# * Connection #0 to host xxx
# {"message":"OK"}

curl -w '\n' \
    -v \
    --aws-sigv4 "aws:amz:${AWS_REGION}:lambda" \
    --user ${AWS_ACCESS_KEY_ID}:${AWS_SECRET_ACCESS_KEY} \
    ${endpoint}invalid/path

# < HTTP/1.1 200 OK
# < Date: Sun, 22 Jun 2025 21:32:27 GMT
# < Content-Type: application/json
# < Content-Length: 16
# < Connection: keep-alive
# < x-amzn-RequestId: 60ddf256-a255-4fa0-8b59-60dec28a0636
# < X-Amzn-Trace-Id: Root=1-6858766b-58c302dc7fb9404d6d689556;Parent=5df0e04d990799e6;Sampled=0;Lineage=1:23e64a83:0
# <
# * Connection #0 to host xxx
# {"message":"OK"}

curl -w '\n' \
    -v \
    --aws-sigv4 "aws:amz:${AWS_REGION}:lambda" \
    --user ${AWS_ACCESS_KEY_ID}:${AWS_SECRET_ACCESS_KEY} \
    https://invalidendpoint.lambda-url.us-east-1.on.aws/

# < HTTP/1.1 403 Forbidden
# < Date: Sun, 29 Jun 2025 05:58:23 GMT
# < Content-Type: application/json
# < Content-Length: 16
# < Connection: keep-alive
# < x-amzn-RequestId: f8a9d9f0-6c75-470a-a9a2-913f463d6dd0
# < x-amzn-ErrorType: AccessDeniedException
# <
# * Connection #0 to host invalidendpoint.lambda-url.us-east-1.on.aws left intact
# {"Message":null}
