endpoint=$(
    aws cloudformation describe-stacks \
        --stack-name APIGateway-HTTP-API-with-LambdaProxy \
        --query "Stacks[0].Outputs[?OutputKey=='APIGatewayHttpApiEndpoint'].OutputValue" \
        --output text
)

curl -w '\n' $endpoint/test/lambda_handler
curl -w '\n' $endpoint/test/dummy
