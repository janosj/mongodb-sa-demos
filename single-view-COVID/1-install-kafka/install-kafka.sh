#!/bin/bash

# Kafka Quickstart instructions (steps 1 and 2):
# https://kafka.apache.org/quickstart

if [[ $EUID -eq 0 ]]; then
   echo "This script should be run as the demo user, not root."
   exit 1
fi

# Set file locations
KAFKA_VER=kafka_2.13-2.8.0
KFILE=$KAFKA_VER.tgz
INSTALL_DIR=$HOME
KAFKA_HOME=$HOME/$KAFKA_VER
PLUGINS_DIR=$KAFKA_HOME/plugins
CONFIG_DIR=$KAFKA_HOME/config

OSTYPE=rhel
if [ ! -f "/etc/redhat-release" ]; then
  OSTYPE=ubuntu
fi
echo
echo "Setting OS type to $OSTYPE."

echo
echo "Installing Java (required by ZooKeeper) ..."
JAVA_VER=java-1.8.0-openjdk-devel
if [ "$OSTYPE" = "rhel" ]; then
  sudo yum install -y $JAVA_VER
else
  sudo apt install $JAVA_VER
fi

# Download Kafka
echo
cd $INSTALL_DIR
if [ ! -f "$KFILE" ]; then
  echo "Kafka not found locally, downloading now ..."
  curl https://downloads.apache.org/kafka/2.8.0/$KFILE --output $KFILE
else
  echo "Found previously downloaded Kafka, using that ..."
fi
tar -xzf $KFILE
cd -

# Create a destination folder for the Connector.
# MongoDB instructions say to use the Kafka plugins directory here: /usr/local/share/kafka/plugins/
# My previous notes say to create a "plugins" directory in the Kafka directory.
mkdir $PLUGINS_DIR

# Download MongoDB-Kafka Connector.
# See here for options: https://docs.mongodb.com/kafka-connector/current/kafka-installation/
# Using Apache Kafka, not Confluent.
# Most options are zip files that you unzip to the plugins directory.
# Simple enough, but it's hard to find a download link and you're stuck doing it manually. 
# Sonatype provides a link to an uber jar, which you simply place in the plugins diretory.
# Follow links for "Uber JAR (Sonatype OSS)".
# In Nexus, select "1.5.0" (top), "xx-all.jar" (bottom), Artifact tab (right), 
# then right-click "Repository Path" for download url.
echo
CONNECTVER=1.5.0
CONNECTJAR=mongo-kafka-connect-$CONNECTVER-all.jar
if [ ! -f "$PLUGINS_DIR/$CONNECTJAR" ]; then
  echo "Connector not found locally, downloading now ..."
  curl https://oss.sonatype.org/service/local/repositories/releases/content/org/mongodb/kafka/mongo-kafka-connect/$CONNECTVER/$CONNECTJAR --output $PLUGINS_DIR/$CONNECTJAR
else
  echo "Found previously downloaded Connector, using that ..."
fi

# The uber jar does not include all required non-MongoDB dependencies.
# For example, attempts to use MDB as a source will fail
# (when starting Kafka Connect) with an avro class not found error.
# Using Sonatype, dependencies can be determined by looking at the
# kafka connect pom file within the Nexus repository Manager.
# The location of these dependencies have to be in your CLASSPATH
# when you start Kafka Connect.
AVRO=avro-1.9.2
echo "Installing dependencies..."
curl http://archive.apache.org/dist/avro/$AVRO/java/$AVRO.jar --output $PLUGINS_DIR/$AVRO.jar

echo
echo "Configuring ..."

# The plugin directory is specified in connect-standalone.properties.
echo "plugin.path=$PLUGINS_DIR" >> $CONFIG_DIR/connect-standalone.properties
# Copy MongoDB Connector config files to Kafka config directory.
cp connect-mongodb-* $CONFIG_DIR
# Configure binding to avoid "leader not found" errors.
cat <<EOF >> $CONFIG_DIR/server.properties

# Added for MongoDB Connector demo to avoid 'leader not found' errors.
# (This may not be right) 
listeners=PLAINTEXT://0.0.0.0:9092
advertised.listeners=PLAINTEXT://localhost:9092
# Added to allow topic deletion
delete.topic.enable=true
EOF

echo "Where to sink? For Atlas, supply the entire Compass connect string."
echo "For example: mongodb+srv://myUser:myPassword@my.cluster.dns/COVID"
read -p "Enter MongoDB Connect String: " MDB_CONNECT_URI
URI_ESCAPED2="${MDB_CONNECT_URI////\\/}"
URI_ESCAPED="${URI_ESCAPED2//@/\\@}"
sed -i "s/MDB_CONNECT_URI/$URI_ESCAPED/g" $CONFIG_DIR/connect-mongodb-sink.properties

echo
echo "RHEL8 comes standard with python3..."
echo "Installing kafka-python package (required by demo producers/consumers)..."
sudo pip3 install kafka-python

echo "Kafka installation and configuration complete."

