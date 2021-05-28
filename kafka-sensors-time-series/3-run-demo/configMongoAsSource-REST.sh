curl -X PUT http://localhost:8083/connectors/source-mongodb-pilotVitalSigns/config -H "Content-Type: application/json" -d '{
      "tasks.max":1,
      "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
      "key.converter":"org.apache.kafka.connect.storage.StringConverter",
      "value.converter":"org.apache.kafka.connect.storage.StringConverter",
      "connection.uri":"mongodb://localhost:27017/admin",
      "database":"ics",
      "collection":"pilotVitalSigns",
      "pipeline":"[{\"$match\": { \"$and\": [ { \"updateDescription.updatedFields.heartRate\" : { \"$gte\": 120 } }, {\"operationType\": \"update\"}]}}]", 
      "topic.prefix": ""
}'

