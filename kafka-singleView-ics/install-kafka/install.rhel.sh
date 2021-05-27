#!/bin/bash

# Kafka Quickstart instructions:
# https://kafka.apache.org/quickstart

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo "Install Java (required by ZooKeeper) ..."
yum install -y java-1.8.0-openjdk-devel

# Download Kafka
INSTALL_DIR=$HOME
KFILE=kafka_2.13-2.8.0.tgz
cd $INSTALL_DIR
if [ ! -f "$KFILE" ]; then
  echo "Kafka not found locally, downloading now ..."
  curl https://downloads.apache.org/kafka/2.8.0/$KFILE --output $KFILE
else
  echo "Found previously downloaded Kafka, using that ..."
fi
tar -xzf $KFILE

# previous version, known to work:
# wget http://apache-mirror.8birdsvideo.com/kafka/2.4.0/kafka_2.12-2.4.0.tgz
# tar -xzf kafka_2.12-2.4.0.tgz

# Create a destination folder for the Connector.
# MongoDB instructions say to use the Kafka plugins directory here: /usr/local/share/kafka/plugins/
# My previous notes say to create a "plugins" directory in the Kafka directory.
PLUGINS_DIR=/usr/local/share/kafka/plugins
mkdir -p $PLUGINS_DIR

# Download MongoDB-Kafka Connector.
# See here for options: https://docs.mongodb.com/kafka-connector/current/kafka-installation/
# Using Apache Kafka, not Confluent.
# Most links are manual downloads, some require manual compilation.
# Sonatype link was used here. Follow links for "Uber JAR (Sonatype OSS)".
# In Nexus, select "1.5.0" (top), "xx-all.jar" (bottom), Artifact tab (right), 
# then right-click "Repository Path" for download url.
# Our Kafka installation directions stop here with locating the jar file.
# For installation, follow the Confluent manual directions:
# https://docs.confluent.io/home/connect/community.html#manually-installing-community-connectors/
CONNECTVER=1.5.0
CONNECTJAR=mongo-kafka-connect-$CONNECTVER-all.jar
if [ ! -f "$PLUGINS_DIR/$CONNECTJAR" ]; then
  echo "Connector not found locally, downloading now ..."
  curl https://oss.sonatype.org/service/local/repositories/releases/content/org/mongodb/kafka/mongo-kafka-connect/$CONNECTVER/$CONNECTJAR --output $PLUGINS_DIR/$CONNECTJAR
else
  echo "Found previously downloaded Connector, using that ..."
fi

cd -

