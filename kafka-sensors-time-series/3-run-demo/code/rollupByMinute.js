//conn = new Mongo("mongodb://localhost:27017/ics?replicaSet=rs");
//db = conn.getDB("ics");
db = db.getSiblingDB('ics'); 
collection = db.pilotVitalSignsHistory;

function sleepFor(sleepDuration) {
  print("Sleeping for " + sleepDuration);
  var now = new Date().getTime();
  while (new Date().getTime() < now + sleepDuration) {
    /* do nothing */
  }
}

function rollupByMinute() {

  cutoff = new Date();
  cutoff.setSeconds(0);
  cutoff.setMilliseconds(0);
  print(cutoff);

  collection.aggregate(
     [
       { $group:
         {
             _id: {  // GroupBy fields
                year: { $year: "$timestamp" },
                month: { $month: "$timestamp" },
                day: { $dayOfMonth: "$timestamp" },
                hour: { $hour: "$timestamp" },
                minute: { $minute: "$timestamp" }
             },      // Aggregations
             minHR: { $min: "$heartRate" },
             maxHR: { $max: "$heartRate" },
             avgHR: { $avg: "$heartRate" },
             numHR: { $sum: 1 }
         }
       },
       { $project: 
         {
          // The _id is the minute, which can be used for sorting.
          _id: { $dateFromParts: { 'year': "$_id.year", 'month': "$_id.month", 'day': "$_id.day", 'hour': "$_id.hour", 'minute': "$_id.minute" } },
          // The parsed time field, which also constitutes the GroupBy fields.
          timeParts: "$_id", 
          heartRate: {
             min: "$minHR",
             max: "$maxHR",
             avg: "$avgHR",
             numberOfReadings: "$numHR"
           },
           // The timestamp when this record was created.
           aggregationTime: new Date()
         }
       },
       { $merge: {
           into: "pilotVitalSignsByMinute"
           // Defaults work here.
           // We don't expect a match - insert new record.
           // If there is a match, merge will overwrite existing values.
           //, whenNotMatched: "insert"
           //, whenMatched: "fail"
         } 
       }
     ]
  )

  res = collection.deleteMany(
     { timestamp: { $lt: cutoff } }
  )
  print(JSON.stringify(res))

  sleepFor(30000);

}

while (true) {
  rollupByMinute();
}

