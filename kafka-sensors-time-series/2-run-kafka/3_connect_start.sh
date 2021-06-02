# Setting allexport causes all variables defined in demo.conf
# to be exported, and thus accessible to subshells.
# Specifically, connect-standalone.sh requires the CLASSPATH.
set -a
source demo.conf

if [ ! -d "$KAFKA_HOME" ]; then
  echo "Kafka not found at $KAFKA_HOME."
  echo "Check that Kafka is installed and KAFKA_HOME is set in demo.conf."
  echo "Exiting."
  exit 1
fi

cd $KAFKA_HOME

bin/connect-standalone.sh config/connect-standalone.properties config/connect-mongodb-source.properties
cd -

