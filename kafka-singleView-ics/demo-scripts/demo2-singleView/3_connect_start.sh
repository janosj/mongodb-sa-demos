rm -f /home/opsmgr/kafkaInputFile.json
touch /home/opsmgr/kafkaInputFile.json

cd /home/opsmgr/kafka_2.12-2.4.0
bin/connect-standalone.sh config/connect-standalone.properties config/connect-mongodb-sink.properties
#bin/connect-standalone.sh config/connect-standalone.properties config/connect-COVIDfile-source.properties config/connect-mongodb-source.properties
