source demo.conf

if [ ! -d "$KAFKA_HOME" ]; then
  echo "Kafka not found at $KAFKA_HOME."
  echo "Check that Kafka is installed and KAFKA_HOME is set in demo.conf."
  echo "Exiting."
  exit 1
fi

cd $KAFKA_HOME

# Remember: Kafka has to be up and running
bin/kafka-topics.sh --zookeeper localhost:2181 --delete --topic COVID
cd -

echo "To really clean things up, shut down Kafka and ZooKeeper and run the cleanup.sh script."


