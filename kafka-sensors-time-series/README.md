# ICS (Integrated Cockpit Sensors)

This time series demo pulls pilot vital signs into MongoDB, where MongoDB [Change Streams](https://docs.mongodb.com/manual/changeStreams/) and the [Connector for Apache Kafka](https://docs.mongodb.com/kafka-connector/current/) can be used to generate alerts and publish notifications to downstream systems. The demo also illustrates the utility of the JSON data model for managing time series data.  

