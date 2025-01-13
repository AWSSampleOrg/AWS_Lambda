from datetime import datetime, UTC
import socket
import kafka
from aws_msk_iam_sasl_signer import MSKAuthTokenProvider

class MSKTokenProvider():
    def token(self):
        token, _ = MSKAuthTokenProvider.generate_auth_token('<my aws region>')
        return token

def main() -> None:
    tp = MSKTokenProvider()

    kafka_producer = kafka.KafkaProducer(
        bootstrap_servers="",
        security_protocol="SASL_SSL",
        #
        # SCRAM
        #
        # sasl_mechanism="SCRAM-SHA-512",
        # sasl_plain_username="",
        # sasl_plain_password="",
        #
        # IAM Auth
        #
        sasl_mechanism='OAUTHBEARER',
        sasl_oauth_token_provider=tp,
        client_id=socket.gethostname()
    )

    try:
        for i in range(10):
            kafka_producer.send(
                topic="",
                key=datetime.now(UTC).isoformat().encode("utf-8"),
                value=str(i).encode("utf-8")
            )
            kafka_producer.flush()
    except Exception as e:
        print(e)
    finally:
        kafka_producer.close()

if __name__ == "__main__":
    main()
