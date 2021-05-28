# Runs scripts 1, 2, and 3 (ZK, Kafka, and Connect), all in the background.
# Strictly a convenience script, it reduces number of pre-meetings steps to just 1.
# Once everything is running, just run start_data_feed.

source demo.conf

if [ ! -d "$KAFKA_HOME" ]; then
  echo "Kafka not found at $KAFKA_HOME."
  echo "Check that Kafka is installed and KAFKA_HOME is set in demo.conf."
  echo "Exiting."
  exit 1
fi

cd $KAFKA_HOME

echo "About to start ZooKeeper in the background..."
sleep 3
bin/zookeeper-server-start.sh config/zookeeper.properties &
sleep 10

echo "About to start Kafka in the background..."
sleep 3
bin/kafka-server-start.sh config/server.properties &
sleep 15

echo "About to start Connect in the background..."
sleep 3
bin/connect-standalone.sh config/connect-standalone.properties config/connect-mongodb-sink.properties &
sleep 25

cd -

echo "Everything should be running, now just run start_data_feed. Good luck!"

