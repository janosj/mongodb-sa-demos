# Fast Iteration with MongoDB

Very simple demonstration to show how MongoDB enables fast iteration. Changes can be made in the application without performing any of the backend schema updates that would be required when using a RDBMS.

<img src="images/MongoDB-easy-to-innovate.png" alt="No Backend Changes" width="800"/>

Step 1: Just launch this simple web form and submit a record to the database. Note how the record looks in MongoDB (I use MongoDB side-by-side with the web form).

Step 2: Modify the web form with an additional field and reload the web form. Resubmit. Presto! Show the data in MongoDB. Note all fields are instantly queryable. You can create secondary indexes, build data pipelines, run analytics, etc. Note how this is much more functional than a simple key-value data store. With Compass open, you could also show JSON Schema validation at this point, to alleviate any concerns about inconsistent/erroneous data models.


