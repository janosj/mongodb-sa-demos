# Fast Iteration with MongoDB

Very simple demonstration to show how MongoDB enables fast iteration. Changes can be made in the application without performing any of the backend schema updates that would be required when using an RDBMS.

<img src="images/MongoDB-easy-to-innovate.png" alt="No Backend Changes" width="800"/>

**Step 1:** Just launch this simple web form and submit a record to the database. Note how the record looks in MongoDB (I use MongoDB Compass side-by-side with the web form).

<img src="images/simpleApp-first-iteration.png" alt="First Iteration" width="800"/>

**Step 2:** Modify the web form with an additional field and reload the web form. Resubmit. Presto! Show the data in MongoDB. Show how all fields are instantly queryable, drawing a distinction between MongoDB and a simple key-value store. You can create secondary indexes, build data pipelines, run analytics, etc. With Compass open, you could show JSON Schema validation at this point, to alleviate any concerns about inconsistent/erroneous data models.

<img src="images/simpleApp-second-iteration.png" alt="Second Iteration" width="800"/>

**Credits:** This demo is a stripped-down version of a demo developed by Matt Groghan ([here](https://github.com/mdg-2018/30-min-data-web-form)), which itself was a node.js adaptation of a MongoDB Atlas demo created by Michael Lynn ([here](https://github.com/mrlynn/30-min-data-web-form)).

