//conn = new Mongo("mongodb://localhost:27017/ics?replicaSet=rs");
//db = conn.getDB("ics");
db = db.getSiblingDB('ics'); 
collection = db.pilotVitalSignsByMinute;

function sleepFor(sleepDuration) {
  print("Sleeping for " + sleepDuration);
  var now = new Date().getTime();
  while (new Date().getTime() < now + sleepDuration) {
    /* do nothing */
  }
}

function bucketize() {

  cutoff = new Date();
  cutoff.setMinutes(0);
  cutoff.setSeconds(0);
  cutoff.setMilliseconds(0);
  print(cutoff);

  collection.aggregate(
     [
       { $match:
         {
           _id: { $lt: cutoff }
         }
       },
       { $sort: { "_id": 1 } },
       { $group:
         {
             _id: { 
                year: "$timeParts.year",
                month: "$timeParts.month",
                day: "$timeParts.day",
                hour: "$timeParts.hour",
             },
             heartRate: {
                $push: { min: "$heartRate.min",
                         max: "$heartRate.max",
                         avg: "$heartRate.avg" }
             }
         }
       },
       { $project: 
        {
          // The _id is the minute, which can be used for sorting.
          _id: { $dateFromParts: { 'year': "$_id.year", 'month': "$_id.month", 'day': "$_id.day", 'hour': "$_id.hour" } },
          // The parsed time field, which also constitutes the GroupBy fields.
          timeParts: "$_id", 
          heartRate: 1,
          // The timestamp when this record was created.
          aggregationTime: new Date()
        }
      },
       //{ $out: "pilotVitalSignsBucketized" }
       { $merge: {
           into: "pilotVitalSignsBucketized"
         } 
       }
     ]
  )

  res = collection.deleteMany(
     { _id: { $lt: cutoff } }
  )
  print(JSON.stringify(res))

  sleepFor(60000);

}

while (true) {
  bucketize();
}

