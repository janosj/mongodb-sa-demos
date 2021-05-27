$KAFKA_VER=kafka_2.13-2.8.0

cd $HOME/$KAFKA_VER
bin/zookeeper-server-start.sh config/zookeeper.properties

