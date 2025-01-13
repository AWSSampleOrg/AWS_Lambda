- Lambda function didn't return response within 29 seconds which is REST API Gateway integration time out.
  - 504 Endpoint request timed out
- Lambda response format is not the one what API Gateway expects.
  - 502 Internal server error
- Resource base policy doesn't allow API Gateway api to invoke your function.
  - 500 Internal server error
- Lambda function is throttling
  - 500 Internal server error
- Errors in Lambda function
  - 502 Internal server error

# Lambda function didn't return response within 29 seconds which is REST API Gateway integration time out.

## 504 Endpoint request timed out

```sh
~ $ time curl -w '\n' -v https://k1k7gu3ct7.execute-api.us-east-1.amazonaws.com/test/lambda_handler
*   Trying 18.67.39.91:443...
* Connected to k1k7gu3ct7.execute-api.us-east-1.amazonaws.com (18.67.39.91) port 443 (#0)
* ALPN: offers h2,http/1.1
* (304) (OUT), TLS handshake, Client hello (1):
*  CAfile: /etc/ssl/cert.pem
*  CApath: none
* (304) (IN), TLS handshake, Server hello (2):
* (304) (IN), TLS handshake, Unknown (8):
* (304) (IN), TLS handshake, Certificate (11):
* (304) (IN), TLS handshake, CERT verify (15):
* (304) (IN), TLS handshake, Finished (20):
* (304) (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / AEAD-AES128-GCM-SHA256
* ALPN: server accepted h2
* Server certificate:
*  subject: CN=*.execute-api.us-east-1.amazonaws.com
*  start date: Apr 19 00:00:00 2025 GMT
*  expire date: May 18 23:59:59 2026 GMT
*  subjectAltName: host "k1k7gu3ct7.execute-api.us-east-1.amazonaws.com" matched cert's "*.execute-api.us-east-1.amazonaws.com"
*  issuer: C=US; O=Amazon; CN=Amazon RSA 2048 M03
*  SSL certificate verify ok.
* using HTTP/2
* h2 [:method: GET]
* h2 [:scheme: https]
* h2 [:authority: k1k7gu3ct7.execute-api.us-east-1.amazonaws.com]
* h2 [:path: /test/lambda_handler]
* h2 [user-agent: curl/8.1.2]
* h2 [accept: */*]
* Using Stream ID: 1 (easy handle 0x13700a800)
> GET /test/lambda_handler HTTP/2
> Host: k1k7gu3ct7.execute-api.us-east-1.amazonaws.com
> User-Agent: curl/8.1.2
> Accept: */*
>
< HTTP/2 504
< content-type: application/json
< content-length: 41
< date: Tue, 20 May 2025 02:40:39 GMT
< x-amzn-trace-id: Root=1-682beb8a-1c0746795c388c4d0b9cfcf9
< x-amzn-requestid: fbcaf9e5-d535-40a1-891c-7b70118cf7e8
< x-amzn-errortype: InternalServerErrorException
< x-amz-apigw-id: K2G9wEbUoAMEvag=
< x-cache: Error from cloudfront
< via: 1.1 12aa3fefbdb5e80269e58f34f94a99e8.cloudfront.net (CloudFront)
< x-amz-cf-pop: YTO50-P2
< x-amz-cf-id: Q2r0iNCnto2LZHQIKtd5zIqYiNKU9CjucQANBrqkDhC17VJzcecNWw==
<
* Connection #0 to host k1k7gu3ct7.execute-api.us-east-1.amazonaws.com left intact
{"message": "Endpoint request timed out"}

real    0m29.230s
user    0m0.016s
sys     0m0.010s
~ $
```

API Gateway Execution log

```log
(fbcaf9e5-d535-40a1-891c-7b70118cf7e8) Execution failed due to a timeout error
(fbcaf9e5-d535-40a1-891c-7b70118cf7e8) Method completed with status: 504
```

# Lambda response format is not the one what API Gateway expects.

## 502 Internal server error

```sh
~ $ time curl -w '\n' -v https://k1k7gu3ct7.execute-api.us-east-1.amazonaws.com/test/lambda_handler
*   Trying 18.67.39.90:443...
* Connected to k1k7gu3ct7.execute-api.us-east-1.amazonaws.com (18.67.39.90) port 443 (#0)
* ALPN: offers h2,http/1.1
* (304) (OUT), TLS handshake, Client hello (1):
*  CAfile: /etc/ssl/cert.pem
*  CApath: none
* (304) (IN), TLS handshake, Server hello (2):
* (304) (IN), TLS handshake, Unknown (8):
* (304) (IN), TLS handshake, Certificate (11):
* (304) (IN), TLS handshake, CERT verify (15):
* (304) (IN), TLS handshake, Finished (20):
* (304) (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / AEAD-AES128-GCM-SHA256
* ALPN: server accepted h2
* Server certificate:
*  subject: CN=*.execute-api.us-east-1.amazonaws.com
*  start date: Apr 19 00:00:00 2025 GMT
*  expire date: May 18 23:59:59 2026 GMT
*  subjectAltName: host "k1k7gu3ct7.execute-api.us-east-1.amazonaws.com" matched cert's "*.execute-api.us-east-1.amazonaws.com"
*  issuer: C=US; O=Amazon; CN=Amazon RSA 2048 M03
*  SSL certificate verify ok.
* using HTTP/2
* h2 [:method: GET]
* h2 [:scheme: https]
* h2 [:authority: k1k7gu3ct7.execute-api.us-east-1.amazonaws.com]
* h2 [:path: /test/lambda_handler]
* h2 [user-agent: curl/8.1.2]
* h2 [accept: */*]
* Using Stream ID: 1 (easy handle 0x11e00a800)
> GET /test/lambda_handler HTTP/2
> Host: k1k7gu3ct7.execute-api.us-east-1.amazonaws.com
> User-Agent: curl/8.1.2
> Accept: */*
>
< HTTP/2 502
< content-type: application/json
< content-length: 36
< date: Tue, 20 May 2025 02:42:25 GMT
< x-amzn-trace-id: Root=1-682bec10-60b89ae21ea8a88a67c53117
< x-amzn-requestid: 8212e5af-c174-48ce-85d5-729d73c6771a
< x-amzn-errortype: InternalServerErrorException
< x-amz-apigw-id: K2HSsHMcIAMEQzw=
< x-cache: Error from cloudfront
< via: 1.1 6889869bf680fe34cca722f0a05e1106.cloudfront.net (CloudFront)
< x-amz-cf-pop: YTO50-P2
< x-amz-cf-id: HTt8HRjTg1p5P_QdbBVH1gREJ6qm2i1w5yktV_yN2zKiZgdW-AZy8w==
<
* Connection #0 to host k1k7gu3ct7.execute-api.us-east-1.amazonaws.com left intact
{"message": "Internal server error"}

real    0m0.513s
user    0m0.021s
sys     0m0.017s
~ $
```

API Gateway Execution log

```log
(8212e5af-c174-48ce-85d5-729d73c6771a) Endpoint response body before transformations: "Bad response"
(8212e5af-c174-48ce-85d5-729d73c6771a) Execution failed due to configuration error: Malformed Lambda proxy response
(8212e5af-c174-48ce-85d5-729d73c6771a) Method completed with status: 502
```

# Resource base policy doesn't allow API Gateway api to invoke your function.

## 500 Internal server error

```sh
~ $ time curl -w '\n' -v https://k1k7gu3ct7.execute-api.us-east-1.amazonaws.com/test/lambda_handler
*   Trying 18.67.39.16:443...
* Connected to k1k7gu3ct7.execute-api.us-east-1.amazonaws.com (18.67.39.16) port 443 (#0)
* ALPN: offers h2,http/1.1
* (304) (OUT), TLS handshake, Client hello (1):
*  CAfile: /etc/ssl/cert.pem
*  CApath: none
* (304) (IN), TLS handshake, Server hello (2):
* (304) (IN), TLS handshake, Unknown (8):
* (304) (IN), TLS handshake, Certificate (11):
* (304) (IN), TLS handshake, CERT verify (15):
* (304) (IN), TLS handshake, Finished (20):
* (304) (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / AEAD-AES128-GCM-SHA256
* ALPN: server accepted h2
* Server certificate:
*  subject: CN=*.execute-api.us-east-1.amazonaws.com
*  start date: Apr 19 00:00:00 2025 GMT
*  expire date: May 18 23:59:59 2026 GMT
*  subjectAltName: host "k1k7gu3ct7.execute-api.us-east-1.amazonaws.com" matched cert's "*.execute-api.us-east-1.amazonaws.com"
*  issuer: C=US; O=Amazon; CN=Amazon RSA 2048 M03
*  SSL certificate verify ok.
* using HTTP/2
* h2 [:method: GET]
* h2 [:scheme: https]
* h2 [:authority: k1k7gu3ct7.execute-api.us-east-1.amazonaws.com]
* h2 [:path: /test/lambda_handler]
* h2 [user-agent: curl/8.1.2]
* h2 [accept: */*]
* Using Stream ID: 1 (easy handle 0x14900c600)
> GET /test/lambda_handler HTTP/2
> Host: k1k7gu3ct7.execute-api.us-east-1.amazonaws.com
> User-Agent: curl/8.1.2
> Accept: */*
>
< HTTP/2 500
< content-type: application/json
< content-length: 36
< date: Tue, 20 May 2025 02:46:41 GMT
< x-amzn-trace-id: Root=1-682bed11-525d3f04507405b029d8d9e1
< x-amzn-requestid: 2b9c8640-30be-4853-bd1b-d3fb0442e3e4
< x-amzn-errortype: InternalServerErrorException
< x-amz-apigw-id: K2H60H42IAMEsHA=
< x-cache: Error from cloudfront
< via: 1.1 4ec5f8da969dc981ba2067c9dad5dad8.cloudfront.net (CloudFront)
< x-amz-cf-pop: YTO50-P2
< x-amz-cf-id: aVyBM-eVARrAWDj8RFoz4HfsiOB5WBNSfP74Qm9AVHi073kgYb0xSA==
<
* Connection #0 to host k1k7gu3ct7.execute-api.us-east-1.amazonaws.com left intact
{"message": "Internal server error"}

real    0m0.103s
user    0m0.019s
sys     0m0.014s
~ $
```

API Gateway Execution log

```log
(73737819-c94c-48d7-86d7-b1700e4be29b) Execution failed due to configuration error: Invalid permissions on Lambda function
(73737819-c94c-48d7-86d7-b1700e4be29b) Method completed with status: 500
```

# Lambda function is throttling

## 500 Internal server error

```sh
~ $ time curl -w '\n' -v https://k1k7gu3ct7.execute-api.us-east-1.amazonaws.com/test/lambda_handler
*   Trying 18.67.39.40:443...
* Connected to k1k7gu3ct7.execute-api.us-east-1.amazonaws.com (18.67.39.40) port 443 (#0)
* ALPN: offers h2,http/1.1
* (304) (OUT), TLS handshake, Client hello (1):
*  CAfile: /etc/ssl/cert.pem
*  CApath: none
* (304) (IN), TLS handshake, Server hello (2):
* (304) (IN), TLS handshake, Unknown (8):
* (304) (IN), TLS handshake, Certificate (11):
* (304) (IN), TLS handshake, CERT verify (15):
* (304) (IN), TLS handshake, Finished (20):
* (304) (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / AEAD-AES128-GCM-SHA256
* ALPN: server accepted h2
* Server certificate:
*  subject: CN=*.execute-api.us-east-1.amazonaws.com
*  start date: Apr 19 00:00:00 2025 GMT
*  expire date: May 18 23:59:59 2026 GMT
*  subjectAltName: host "k1k7gu3ct7.execute-api.us-east-1.amazonaws.com" matched cert's "*.execute-api.us-east-1.amazonaws.com"
*  issuer: C=US; O=Amazon; CN=Amazon RSA 2048 M03
*  SSL certificate verify ok.
* using HTTP/2
* h2 [:method: GET]
* h2 [:scheme: https]
* h2 [:authority: k1k7gu3ct7.execute-api.us-east-1.amazonaws.com]
* h2 [:path: /test/lambda_handler]
* h2 [user-agent: curl/8.1.2]
* h2 [accept: */*]
* Using Stream ID: 1 (easy handle 0x13f00a800)
> GET /test/lambda_handler HTTP/2
> Host: k1k7gu3ct7.execute-api.us-east-1.amazonaws.com
> User-Agent: curl/8.1.2
> Accept: */*
>
< HTTP/2 500
< content-type: application/json
< content-length: 36
< date: Tue, 20 May 2025 02:50:13 GMT
< x-amzn-trace-id: Root=1-682bede5-49c989cb399a3c820e0be45c
< x-amzn-requestid: 394365dc-1b10-411f-9668-70521cec1205
< x-amzn-errortype: InternalServerErrorException
< x-amz-apigw-id: K2Ib_G66IAMEF6g=
< x-cache: Error from cloudfront
< via: 1.1 12aa3fefbdb5e80269e58f34f94a99e8.cloudfront.net (CloudFront)
< x-amz-cf-pop: YTO50-P2
< x-amz-cf-id: spPv7sICXFVuTaxo2sehOW5LUxajdpcE-lsoCD-aF3IWD_QOkUL4lw==
<
* Connection #0 to host k1k7gu3ct7.execute-api.us-east-1.amazonaws.com left intact
{"message": "Internal server error"}

real    0m0.105s
user    0m0.017s
sys     0m0.016s
~ $
```

API Gateway Execution log

```log
(394365dc-1b10-411f-9668-70521cec1205) Lambda invocation failed with status: 429. Lambda request id: dcb2ab89-2d03-4b77-98cd-18d14fd2b850
(394365dc-1b10-411f-9668-70521cec1205) Execution failed due to configuration error: Rate Exceeded.
(394365dc-1b10-411f-9668-70521cec1205) Method completed with status: 500
```

# Errors in Lambda function

## 502 Internal server error

```sh
~ $ time curl -w '\n' -v https://k1k7gu3ct7.execute-api.us-east-1.amazonaws.com/test/lambda_handler
*   Trying 18.67.39.90:443...
* Connected to k1k7gu3ct7.execute-api.us-east-1.amazonaws.com (18.67.39.90) port 443 (#0)
* ALPN: offers h2,http/1.1
* (304) (OUT), TLS handshake, Client hello (1):
*  CAfile: /etc/ssl/cert.pem
*  CApath: none
* (304) (IN), TLS handshake, Server hello (2):
* (304) (IN), TLS handshake, Unknown (8):
* (304) (IN), TLS handshake, Certificate (11):
* (304) (IN), TLS handshake, CERT verify (15):
* (304) (IN), TLS handshake, Finished (20):
* (304) (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / AEAD-AES128-GCM-SHA256
* ALPN: server accepted h2
* Server certificate:
*  subject: CN=*.execute-api.us-east-1.amazonaws.com
*  start date: Apr 19 00:00:00 2025 GMT
*  expire date: May 18 23:59:59 2026 GMT
*  subjectAltName: host "k1k7gu3ct7.execute-api.us-east-1.amazonaws.com" matched cert's "*.execute-api.us-east-1.amazonaws.com"
*  issuer: C=US; O=Amazon; CN=Amazon RSA 2048 M03
*  SSL certificate verify ok.
* using HTTP/2
* h2 [:method: GET]
* h2 [:scheme: https]
* h2 [:authority: k1k7gu3ct7.execute-api.us-east-1.amazonaws.com]
* h2 [:path: /test/lambda_handler]
* h2 [user-agent: curl/8.1.2]
* h2 [accept: */*]
* Using Stream ID: 1 (easy handle 0x13880ba00)
> GET /test/lambda_handler HTTP/2
> Host: k1k7gu3ct7.execute-api.us-east-1.amazonaws.com
> User-Agent: curl/8.1.2
> Accept: */*
>
< HTTP/2 502
< content-type: application/json
< content-length: 36
< date: Tue, 20 May 2025 03:48:59 GMT
< x-amzn-trace-id: Root=1-682bfbaa-1f97d8883a493cf26680a75e
< x-amzn-requestid: 5293df93-f895-46ee-8c21-1471f0d0cef0
< x-amzn-errortype: InternalServerErrorException
< x-amz-apigw-id: K2RCxGG-oAMEjSQ=
< x-cache: Error from cloudfront
< via: 1.1 4ec5f8da969dc981ba2067c9dad5dad8.cloudfront.net (CloudFront)
< x-amz-cf-pop: YTO50-P2
< x-amz-cf-id: oj2_QJmk-Xh6gTS_4N-0HkdHVmKRoFSPduAQK3EN7Rgq9RqEdKqsgg==
<
* Connection #0 to host k1k7gu3ct7.execute-api.us-east-1.amazonaws.com left intact
{"message": "Internal server error"}

real    0m0.388s
user    0m0.018s
sys     0m0.013s
~ $
```

API Gateway Execution log

```log
(5293df93-f895-46ee-8c21-1471f0d0cef0) Lambda execution failed with status 200 due to customer function error: Application error in a Lambda function. Lambda request id: 758a8c2f-35eb-4713-b55e-56879fbc968b
(5293df93-f895-46ee-8c21-1471f0d0cef0) Method completed with status: 502
```
