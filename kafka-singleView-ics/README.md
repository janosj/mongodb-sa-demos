# Kafka Integration: 2 Demos

These demos have Kafka in common, so they have been collocated here to reuse the kafka installation script, as well as to provide options if the intent is to demonstrate kafka integration.

* **Demo 1: Self-Service Data Access (a.k.a. Single View), based on COVID data reporting**
* **Demo 2: ICS (Integrated Cockpit Sensors), a time series and IoT scenario**

Single View demonstrates the utility of the JSON data model when bringing in non-uniform data from disparate systems (using Kafka).  Kafka is used here as a source.

ICS demonstrates the ability to bring sensor data into MongoDB, along with some data modeling techniques you can then apply to time series data.
Change streams and the Kafka Connector are two mechanisms available to filter for specific events of interest and publish them for downstream consumption. Kafka is used here as a sink.

Additional documentation for each demo can be found in their respective "run" directories.
