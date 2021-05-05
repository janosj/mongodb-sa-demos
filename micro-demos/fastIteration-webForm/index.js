const express = require('express')
const path = require('path')
const app = express()
const port = 8081
const credentials = require('./key.json');

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname + '/web/index.html'));
})
app.use(express.static('web'));
app.use(express.json());

app.post('/insertDocument', (req, res) => {
    insertDocument(req.body).then((result) => {
        res.send(JSON.stringify(result));
    })
})

app.listen(port, () => console.log(`App listening on port ${port}!`))

function insertDocument(doc) {
    return new Promise(function (resolve, reject) {
        const MongoClient = require('mongodb').MongoClient;
        //put your MongoDB connection string here!
//        const uri = `mongodb+srv://demo-user:${credentials.password}@sandbox-quel1.mongodb.net/DEMO?retryWrites=true&w=majority`; 
        //const uri = `mongodb://myserver1:27021/?readPreference=primary&appname=MongoDB%20Compass&ssl=false`; 
        //const uri = `mongodb://sandbox1:27017`; 
        const uri = `mongodb://localhost:27017`; 
        const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });
        client.connect(err => {
            if(err){
                console.log(err);
                reject(err);
            }
            const collection = client.db("DEMO").collection("workflow");
            collection.insertOne(doc).then((result) => {
                resolve(result);
            });

        });
    })


}
