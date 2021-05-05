# Fast Iteration with MongoDB

Very simple demonstration to show how MongoDB enables fast iteration. Changes can be made in the application without performing any of the backend schema updates that would be required when using an RDBMS.

<img src="images/MongoDB-easy-to-innovate.png" alt="No Backend Changes" width="800"/>

**Step 1:** Just launch this simple web form and submit a record to the database. Note how the record looks in MongoDB (I use MongoDB Compass side-by-side with the web form).

<img src="images/simpleApp-first-iteration.png" alt="First Iteration" width="800"/>

**Step 2:** Modify the web form to accomodate separate first and last names, then reload the web form. Resubmit. Presto! Show the data in MongoDB using Compass. Show how all fields are instantly queryable (e.g. query on approvedBy.lastName), drawing a distinction between MongoDB and a simple key-value store. You can create secondary indexes, build data pipelines, run analytics, etc. With Compass open, you could show JSON Schema validation at this point, to alleviate any concerns about inconsistent/erroneous data models (e.g. require approvedBy.lastName).

<img src="images/simpleApp-second-iteration.png" alt="Second Iteration" width="800"/>

**Setup:** Node.js has to be installed. From the <em>code</em> directory, run "npm install" to install the dependencies defined in <em>package.json</em>. In <em>index.js</em>, modify the MongoDB connect string to connect to your database. Passwords can be put in the key.json file. Run the app with "node index.js". The web form is in <em>index.html</em>. The 2 required code changes to get from v1 of the form to v2 are clearly commented in the code - just make these changes on-the-fly in the demo using your favorite code editor, save the changes, and then reload the form in your web browser. Backup versions of both v1 and v2 forms are only there in case you ever forget to undo your work at the end of the demo.

**Credits:** This demo is a stripped-down version of a demo developed by Matt Groghan ([here](https://github.com/mdg-2018/30-min-data-web-form)), which itself was a node.js adaptation of a MongoDB Atlas demo created by Michael Lynn ([here](https://github.com/mrlynn/30-min-data-web-form)).

