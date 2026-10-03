# Lambda function didn't return response within 30 seconds which is HTTP API Gateway integration time out.

## 503 Service Unavailable

```sh
~ $ time curl -w '\n' -v https://8gdcomkvu4.execute-api.us-east-1.amazonaws.com/test/lambda_handler
*   Trying 44.193.134.165:443...
* Connected to 8gdcomkvu4.execute-api.us-east-1.amazonaws.com (44.193.134.165) port 443 (#0)
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
*  start date: Jun 23 00:00:00 2024 GMT
*  expire date: Jul 21 23:59:59 2025 GMT
*  subjectAltName: host "8gdcomkvu4.execute-api.us-east-1.amazonaws.com" matched cert's "*.execute-api.us-east-1.amazonaws.com"
*  issuer: C=US; O=Amazon; CN=Amazon RSA 2048 M02
*  SSL certificate verify ok.
* using HTTP/2
* h2 [:method: GET]
* h2 [:scheme: https]
* h2 [:authority: 8gdcomkvu4.execute-api.us-east-1.amazonaws.com]
* h2 [:path: /test/lambda_handler]
* h2 [user-agent: curl/8.1.2]
* h2 [accept: */*]
* Using Stream ID: 1 (easy handle 0x12300b800)
> GET /test/lambda_handler HTTP/2
> Host: 8gdcomkvu4.execute-api.us-east-1.amazonaws.com
> User-Agent: curl/8.1.2
> Accept: */*
>
< HTTP/2 503
< date: Tue, 20 May 2025 04:44:13 GMT
< content-type: application/json
< content-length: 33
< apigw-requestid: K2ZEDjwtIAMEcig=
<
* Connection #0 to host 8gdcomkvu4.execute-api.us-east-1.amazonaws.com left intact
{"message":"Service Unavailable"}

real    0m30.163s
user    0m0.016s
sys     0m0.010s
~ $
```

# Lambda response format is not the one what API Gateway expects.

https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-integrations-lambda.html

## 500 Internal Server Error

```sh
~ $ time curl -w '\n' -v https://8gdcomkvu4.execute-api.us-east-1.amazonaws.com/test/lambda_handler
*   Trying 44.193.134.165:443...
* Connected to 8gdcomkvu4.execute-api.us-east-1.amazonaws.com (44.193.134.165) port 443 (#0)
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
*  start date: Jun 23 00:00:00 2024 GMT
*  expire date: Jul 21 23:59:59 2025 GMT
*  subjectAltName: host "8gdcomkvu4.execute-api.us-east-1.amazonaws.com" matched cert's "*.execute-api.us-east-1.amazonaws.com"
*  issuer: C=US; O=Amazon; CN=Amazon RSA 2048 M02
*  SSL certificate verify ok.
* using HTTP/2
* h2 [:method: GET]
* h2 [:scheme: https]
* h2 [:authority: 8gdcomkvu4.execute-api.us-east-1.amazonaws.com]
* h2 [:path: /test/lambda_handler]
* h2 [user-agent: curl/8.1.2]
* h2 [accept: */*]
* Using Stream ID: 1 (easy handle 0x14a80b200)
> GET /test/lambda_handler HTTP/2
> Host: 8gdcomkvu4.execute-api.us-east-1.amazonaws.com
> User-Agent: curl/8.1.2
> Accept: */*
>
< HTTP/2 500
< date: Tue, 20 May 2025 04:42:48 GMT
< content-type: application/json
< content-length: 35
< apigw-requestid: K2Y7ahA7IAMEJkw=
<
* Connection #0 to host 8gdcomkvu4.execute-api.us-east-1.amazonaws.com left intact
{"message":"Internal Server Error"}

real    0m0.386s
user    0m0.013s
sys     0m0.010s
~ $
```

# Resource base policy doesn't allow API Gateway api to invoke your function.

## 500 Internal Server Error

```sh
~ $ time curl -w '\n' -v https://8gdcomkvu4.execute-api.us-east-1.amazonaws.com/test/lambda_handler
*   Trying 34.204.127.6:443...
* Connected to 8gdcomkvu4.execute-api.us-east-1.amazonaws.com (34.204.127.6) port 443 (#0)
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
*  start date: Jun 23 00:00:00 2024 GMT
*  expire date: Jul 21 23:59:59 2025 GMT
*  subjectAltName: host "8gdcomkvu4.execute-api.us-east-1.amazonaws.com" matched cert's "*.execute-api.us-east-1.amazonaws.com"
*  issuer: C=US; O=Amazon; CN=Amazon RSA 2048 M02
*  SSL certificate verify ok.
* using HTTP/2
* h2 [:method: GET]
* h2 [:scheme: https]
* h2 [:authority: 8gdcomkvu4.execute-api.us-east-1.amazonaws.com]
* h2 [:path: /test/lambda_handler]
* h2 [user-agent: curl/8.1.2]
* h2 [accept: */*]
* Using Stream ID: 1 (easy handle 0x140814c00)
> GET /test/lambda_handler HTTP/2
> Host: 8gdcomkvu4.execute-api.us-east-1.amazonaws.com
> User-Agent: curl/8.1.2
> Accept: */*
>
< HTTP/2 500
< date: Tue, 20 May 2025 04:47:06 GMT
< content-type: application/json
< content-length: 35
< apigw-requestid: K2Zjqj7voAMEbiw=
<
* Connection #0 to host 8gdcomkvu4.execute-api.us-east-1.amazonaws.com left intact
{"message":"Internal Server Error"}

real    0m0.168s
user    0m0.016s
sys     0m0.010s
~ $
```

# Lambda function is throttling

## 503 Service Unavailable

```sh
~ $ time curl -w '\n' -v https://8gdcomkvu4.execute-api.us-east-1.amazonaws.com/test/lambda_handler
*   Trying 34.204.127.6:443...
* Connected to 8gdcomkvu4.execute-api.us-east-1.amazonaws.com (34.204.127.6) port 443 (#0)
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
*  start date: Jun 23 00:00:00 2024 GMT
*  expire date: Jul 21 23:59:59 2025 GMT
*  subjectAltName: host "8gdcomkvu4.execute-api.us-east-1.amazonaws.com" matched cert's "*.execute-api.us-east-1.amazonaws.com"
*  issuer: C=US; O=Amazon; CN=Amazon RSA 2048 M02
*  SSL certificate verify ok.
* using HTTP/2
* h2 [:method: GET]
* h2 [:scheme: https]
* h2 [:authority: 8gdcomkvu4.execute-api.us-east-1.amazonaws.com]
* h2 [:path: /test/lambda_handler]
* h2 [user-agent: curl/8.1.2]
* h2 [accept: */*]
* Using Stream ID: 1 (easy handle 0x12f014000)
> GET /test/lambda_handler HTTP/2
> Host: 8gdcomkvu4.execute-api.us-east-1.amazonaws.com
> User-Agent: curl/8.1.2
> Accept: */*
>
< HTTP/2 503
< date: Tue, 20 May 2025 04:45:09 GMT
< content-type: application/json
< content-length: 33
< apigw-requestid: K2ZRZgLwoAMEbag=
<
* Connection #0 to host 8gdcomkvu4.execute-api.us-east-1.amazonaws.com left intact
{"message":"Service Unavailable"}

real    0m0.173s
user    0m0.021s
sys     0m0.017s
~ $
```

# Errors in Lambda function

## 500 Internal Server Error

```sh
~ $ time curl -w '\n' -v https://8gdcomkvu4.execute-api.us-east-1.amazonaws.com/test/lambda_handler
*   Trying 34.204.127.6:443...
* Connected to 8gdcomkvu4.execute-api.us-east-1.amazonaws.com (34.204.127.6) port 443 (#0)
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
*  start date: Jun 23 00:00:00 2024 GMT
*  expire date: Jul 21 23:59:59 2025 GMT
*  subjectAltName: host "8gdcomkvu4.execute-api.us-east-1.amazonaws.com" matched cert's "*.execute-api.us-east-1.amazonaws.com"
*  issuer: C=US; O=Amazon; CN=Amazon RSA 2048 M02
*  SSL certificate verify ok.
* using HTTP/2
* h2 [:method: GET]
* h2 [:scheme: https]
* h2 [:authority: 8gdcomkvu4.execute-api.us-east-1.amazonaws.com]
* h2 [:path: /test/lambda_handler]
* h2 [user-agent: curl/8.1.2]
* h2 [accept: */*]
* Using Stream ID: 1 (easy handle 0x14580a800)
> GET /test/lambda_handler HTTP/2
> Host: 8gdcomkvu4.execute-api.us-east-1.amazonaws.com
> User-Agent: curl/8.1.2
> Accept: */*
>
< HTTP/2 500
< date: Tue, 20 May 2025 04:46:05 GMT
< content-type: application/json
< content-length: 35
< apigw-requestid: K2ZaIiV-oAMEbiw=
<
* Connection #0 to host 8gdcomkvu4.execute-api.us-east-1.amazonaws.com left intact
{"message":"Internal Server Error"}

real    0m0.406s
user    0m0.022s
sys     0m0.016s
~ $
```
