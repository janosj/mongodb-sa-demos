// Listens to a Change Stream
// Captures updates where heart rate is above 120 bpm.
// Displays each alert.

//conn = new Mongo("mongodb://localhost:27017/ics?replicaSet=rs");
//db = conn.getDB("ics");
db = db.getSiblingDB('ics');
collection = db.pilotVitalSigns;

let updateOps = {
  $match: {
    $and: [
      { "updateDescription.updatedFields.heartRate": { $gte: 120 } },
      { operationType: "update" }
    ]
  }
};

const changeStreamCursor = collection.watch([updateOps]);

pollStream(changeStreamCursor);

// Poll the change stream.
// Print out each change as it comes in.
function pollStream(cursor) {
  while (!cursor.isExhausted()) {
    if (cursor.hasNext()) {
      change = cursor.next();
      print(JSON.stringify(change));
      print();
    }
  }
  pollStream(cursor);
}

