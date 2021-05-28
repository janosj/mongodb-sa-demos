source demo.conf

if [ ! -d "$KAFKA_HOME" ]; then
  echo "Kafka not found at $KAFKA_HOME."
  echo "Check that Kafka is installed and KAFKA_HOME is set in demo.conf."
  echo "Exiting."
  exit 1
fi

cd $KAFKA_HOME
bin/zookeeper-server-start.sh config/zookeeper.properties
cd -

