// Simulates a heart rate sensor.
// Heart rate starts at 100, increases by 2 every second.
// Collection contains a single document, 
// Updated every second with new value.  

//conn = new Mongo("mongodb://localhost:27017/ics?replicaSet=rs");
//db = conn.getDB("ics");
db = db.getSiblingDB('ics'); 
collection = db.pilotVitalSigns;

function sleepFor(sleepDuration) {
  var now = new Date().getTime();
  while (new Date().getTime() < now + sleepDuration) {
    /* do nothing */
  }
}

function update() {

  sleepFor(1000);

  // new:true returns the modified document rather than the original.
  res = collection.findAndModify( { update: { $inc: { heartRate: 2 }, $set: { timestamp: new Date() } }, new: true } );
  
  print("Updated heart rate reading: " + res.heartRate);

}


// Start with an empty collection.
res = collection.remove( {} );

// Set initial heart rate to 100 beats per minute
heartRate = 100

// Insert initial document.
var docToInsert = { heartRate: 0 };
docToInsert.heartRate = heartRate;
res = collection.insert(docToInsert);

while (true) {
  update();
}
