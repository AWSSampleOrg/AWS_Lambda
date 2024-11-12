from datetime import datetime
import kafka


def main() -> None:
    kafka_producer = kafka.KafkaProducer(
        bootstrap_servers="",
        api_version=(0, 11, 5)
    )

    topic = ""

    for i in range(10):
        key = str(datetime.now()).encode("utf-8")
        kafka_producer.send(
            topic=topic,
            key=key,
            value=f"index: {i}"
        )

if __name__ == "__main__":
    main()
