import json
import datetime
import socket
import kafka
import boto3

secrets_manager = boto3.client("secretsmanager")

def get_scram_credentials():
    return json.loads(secrets_manager.get_secret_value(SecretId='')["SecretString"])

def main() -> None:
    credentials = get_scram_credentials()

    kafka_producer = kafka.KafkaProducer(
        bootstrap_servers="",
        security_protocol="SASL_SSL",
        sasl_mechanism="SCRAM-SHA-512",
        sasl_plain_username=credentials["username"],
        sasl_plain_password=credentials["password"],
        client_id=socket.gethostname()
    )

    try:
        for i in range(10):
            kafka_producer.send(
                topic="",
                key=datetime.datetime.now(datetime.UTC).isoformat().encode("utf-8"),
                value=str(i).encode("utf-8")
            )
            kafka_producer.flush()
    except Exception as e:
        print(e)
    finally:
        kafka_producer.close()

if __name__ == "__main__":
    main()
