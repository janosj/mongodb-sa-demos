# Remember: this has to be done while Kafka is up and running

../kafka_2.12-2.4.0/bin/kafka-topics.sh --zookeeper localhost:2181 --delete --topic COVID

echo "To really clean things up, shut down Kafka and ZooKeeper and run the reset_data.sh script."


