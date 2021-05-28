// Simulates a heart rate sensor.
// Heart rate starts at 100, increases by 2 every second.
// Collection contains a single document, 
// Updated every second with new value.  

// MODIFIED: MODIFIED TO WORK WITHOUT A REPLICA SET. 
// USES INSERTS INSTEAD OF UPDATES

db = db.getSiblingDB('ics'); 

function sleepFor(sleepDuration) {
  var now = new Date().getTime();
  while (new Date().getTime() < now + sleepDuration) {
    /* do nothing */
  }
}

function update() {
  sleepFor(1000);
  docToInsert.timestamp = new ISODate();
  docToInsert.heartRate += 2;

  res = db.pilotVitalSignsHistory.insertOne(docToInsert);
  print("Inserted new heart rate reading: " + docToInsert.heartRate);
}


// Start with an empty collection.
//res = db.pilotVitalSignsHistory.remove( {} );

// Set initial heart rate to 100 beats per minute
heartRate = 100

// Insert initial document.
var docToInsert = { timestamp: 0, heartRate: 0 };
docToInsert.heartRate = heartRate;

while (true) {
  update();
}
