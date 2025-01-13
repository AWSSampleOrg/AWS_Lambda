endpoint=''

####################################################################################
# With Resource base policy
####################################################################################
# {
#   "Version": "2012-10-17",
#   "Id": "default",
#   "Statement": [
#     {
#       "Sid": "FunctionURLAllowPublicAccess",
#       "Effect": "Allow",
#       "Principal": "*",
#       "Action": "lambda:InvokeFunctionUrl",
#       "Resource": "Lambda Function ARN",
#       "Condition": {
#         "StringEquals": {
#           "lambda:FunctionUrlAuthType": "NONE"
#         }
#       }
#     }
#   ]
# }

curl -w '\n' \-v $endpoint

# < HTTP/1.1 200 OK
# < Date: Sun, 22 Jun 2025 21:35:16 GMT
# < Content-Type: application/json
# < Content-Length: 16
# < Connection: keep-alive
# < x-amzn-RequestId: 7475d84c-f8da-4264-9191-9daea72df53c
# < X-Amzn-Trace-Id: Root=1-68587714-6dc6751e7947ce1a6e80020b;Parent=2666fea3d1207b28;Sampled=0;Lineage=1:23e64a83:0
# <
# * Connection #0 to host xxx
# {"message":"OK"}

####################################################################################
# Without Resource base policy
####################################################################################

# < HTTP/1.1 403 Forbidden
# < Date: Sun, 22 Jun 2025 21:36:19 GMT
# < Content-Type: application/json
# < Content-Length: 23
# < Connection: keep-alive
# < x-amzn-RequestId: 31b73f03-9469-424c-808b-251ab53229d2
# < x-amzn-ErrorType: AccessDeniedException
# <
# * Connection #0 to host xxx
# {"Message":"Forbidden"}

# Retrieved warning message from Lambda console.
#
# Your function URL auth type is NONE, but is missing permissions required for public access.
# To allow unauthenticated requests, choose the Permissions tab and and create a resource-based policy that grants lambda:invokeFunctionUrl permissions to all principals (*).
# Alternatively, you can update your function URL auth type to AWS_IAM to use IAM authentication.
