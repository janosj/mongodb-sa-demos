// Listens to a Change Stream
// Captures every update to the heart rate.
// Displays each change record.
// Writes record to history table.

//conn = new Mongo("mongodb://localhost:27017/ics?replicaSet=rs");
//db = conn.getDB("ics");

db = db.getSiblingDB('ics');
collection = db.pilotVitalSigns;
historyCollection = db.pilotVitalSignsHistory;

// Start with an empty history.
res = historyCollection.remove( {} );

// History document
var docToInsert = { timestamp: 0, heartRate: 0 };

// const changeStreamCursor = collection.watch( [ { $match : {"operationType" : "update" } } ], { fullDocument: "updateLookup" } );
const changeStreamCursor = collection.watch( [ { $match : {"operationType" : "update" } } ] );

print("");
print ("Listening for sensor readings...");

pollStream(changeStreamCursor);
// Never executes.

//this function polls a change stream and prints out each change as it comes in
function pollStream(cursor) {

  while (!cursor.isExhausted()) {

    if (cursor.hasNext()) {

      var change = cursor.next();
      //print(JSON.stringify(change));
      //print();

      // Insert record into history data set.
      // docToInsert = change.fullDocument;
      docToInsert.timestamp = new ISODate();
      docToInsert.heartRate = change.updateDescription.updatedFields.heartRate;

      print("New reading detected: " + docToInsert.heartRate); 
      res = historyCollection.insertOne(docToInsert);

    }

  }

  print("polling again");
  pollStream(cursor);

}

