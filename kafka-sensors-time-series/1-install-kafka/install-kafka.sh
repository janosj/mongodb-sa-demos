#!/bin/bash

# Kafka Quickstart instructions (steps 1 and 2):
# https://kafka.apache.org/quickstart

echo "This script will install Kafka + the MongoDB Kafka Connector"
echo "and configure the connector to attach to a MongoDB instance as a source."
echo "The MongoDB source must be a replica set (not a standalone)."
echo "MongoDB Atlas qualifies."
echo

if [[ $EUID -eq 0 ]]; then
   echo "This script should be run as the demo user, not root. Exiting."
   echo
   exit 1
fi

echo "MongoDB source: Enter your MongoDB connect string:"
echo "  example (local MDB): mongodb://localhost:27017/admin&replSet=myReplicaSet"
echo "  example (Atlas): mongodb+srv://myUser:myPassword@my.cluster.dns/ICS"
read -p "Enter MongoDB Connect String: " MDB_CONNECT_URI_RAW
# Encode any ampersands
MDB_CONNECT_URI=${MDB_CONNECT_URI_RAW/&/\\&}

# Set file locations
KAFKA_VER=kafka_2.13-2.8.0
KFILE=$KAFKA_VER.tgz
DOWNLOADS_DIR=$HOME/downloads
INSTALL_DIR=$HOME
KAFKA_HOME=$HOME/$KAFKA_VER
PLUGINS_DIR=$KAFKA_HOME/plugins
CONFIG_DIR=$KAFKA_HOME/config

mkdir -p $DOWNLOADS_DIR

echo
echo "Installing Java (required by ZooKeeper) ..."

if [ -f "/etc/redhat-release" ]; then
  OSTYPE=rhel
  sudo yum install -y java-1.8.0-openjdk-devel
else
  OSTYPE=ubuntu
  sudo apt-get install openjdk-8-jdk
fi
echo
echo "OS type is $OSTYPE."

# Download Kafka
echo
if [ ! -f "$DOWNLOADS_DIR/$KFILE" ]; then
  echo "Kafka not found locally, downloading now ..."
  curl https://downloads.apache.org/kafka/2.8.0/$KFILE --output $DOWNLOADS_DIR/$KFILE
else
  echo "Found previously downloaded Kafka, using that ..."
fi
tar -C $INSTALL_DIR -xzf $DOWNLOADS_DIR/$KFILE

# Create a destination folder for the Connector.
# MongoDB instructions say to use the Kafka plugins directory here: /usr/local/share/kafka/plugins/
# My previous notes say to create a "plugins" directory in the Kafka directory.
mkdir $PLUGINS_DIR

# Download MongoDB-Kafka Connector.
# See here for options: https://docs.mongodb.com/kafka-connector/current/kafka-installation/
# Using Apache Kafka, not Confluent.
# Most options are zip files that you unzip to the plugins directory.
# Simple enough, but it's hard to find a download link and you're stuck doing it manually. 
# Sonatype provides a link to an uber jar, which you simply place in the plugins directory.
# Follow links for "Uber JAR (Sonatype OSS)".
# In Nexus, select "1.5.0" (top), "xx-all.jar" (bottom), Artifact tab (right), 
# then right-click "Repository Path" for download url.
echo
CONNECTVER=1.5.0
CONNECTJAR=mongo-kafka-connect-$CONNECTVER-all.jar
if [ ! -f "$DOWNLOADS_DIR/$CONNECTJAR" ]; then
  echo "Connector not found locally, downloading now ..."
  curl https://oss.sonatype.org/service/local/repositories/releases/content/org/mongodb/kafka/mongo-kafka-connect/$CONNECTVER/$CONNECTJAR --output $DOWNLOADS_DIR/$CONNECTJAR
else
  echo "Found previously downloaded Connector, using that ..."
fi
cp $DOWNLOADS_DIR/$CONNECTJAR $PLUGINS_DIR

# The uber jar does not include all required non-MongoDB dependencies.
# For example, attempts to use MDB as a source will fail 
# (when starting Kafka Connect) with an avro class not found error.
# Using Sonatype, dependencies can be determined by looking at the 
# kafka connect pom file within the Nexus repository Manager.
# The location of these dependencies have to be in your CLASSPATH
# when you start Kafka Connect.
AVRO=avro-1.9.2
echo "Installing dependencies..."
if [ ! -f "$DOWNLOADS_DIR/$AVRO.jar" ]; then
  echo "  Avro jar not found locally, downloading now ..."
  curl http://archive.apache.org/dist/avro/$AVRO/java/$AVRO.jar --output $DOWNLOADS_DIR/$AVRO.jar
else
  echo "  Found previously downloaded Avro jar, using that ..."
fi
cp $DOWNLOADS_DIR/$AVRO.jar $PLUGINS_DIR

echo
echo "Configuring ..."

# The plugin directory is specified in connect-standalone.properties.
echo "plugin.path=$PLUGINS_DIR" >> $CONFIG_DIR/connect-standalone.properties

# Copy MongoDB Connector config files to Kafka config directory.
cp connect-mongodb-* $CONFIG_DIR

# Add the user-supplied MongoDB connect string
# Use ',' as separator to correctly parse URLs without complex escape sequences.
sed -i "s,MDB_CONNECT_URI,$MDB_CONNECT_URI,g" $CONFIG_DIR/connect-mongodb-source.properties

# Configure binding to avoid "leader not found" errors.
cat <<EOF >> $CONFIG_DIR/server.properties

# Added for MongoDB Connector demo to avoid 'leader not found' errors.
# (This may not be right) 
listeners=PLAINTEXT://0.0.0.0:9092
advertised.listeners=PLAINTEXT://localhost:9092
# Added to allow topic deletion
delete.topic.enable=true
EOF

echo
echo "RHEL8 comes standard with python3..."
echo "Installing kafka-python package (required by demo producers/consumers)..."
sudo pip3 install kafka-python

echo "Kafka installation and configuration complete."
echo

echo "Writing Kafka Home and MDB connect string to ../3-run-demo/demo.conf..."
# Use ',' as separator to correctly parse URLs without complex escape sequences.
sed -i "s,AUTOREPLACE_MDB_CONNECT_URI,$MDB_CONNECT_URI,g" ../3-run-demo/demo.conf
sed -i "s,AUTOREPLACE_KAFKA_HOME,$KAFKA_HOME,g" ../3-run-demo/demo.conf

echo 
echo "Installation complete."
echo "Required software was downloaded to $DOWNLOADS_DIR"
echo "and Kafka was installed to $KAFKA_HOME."
echo "The MongoDB Kafka Connector was installed to $PLUGINS_DIR."
echo
echo "Run the 3 Kafka components (ZK, Kafka, Connect) and then run your demo."
echo "Good luck!"
echo

