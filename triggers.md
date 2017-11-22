## Triggers in Cassandra ##

The directory 'bin' contains a jar with a trigger definition, just as defined in the cassandra examples (see https://github.com/apache/cassandra/tree/trunk/examples/triggers)

First run the trigger.sh script in this repository to download the trigger file, its configuration and to tell Cassandra to activate it. You can run it, for instance, like that 
```
wget -qO- https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/trigger.sh | bash 
```

Once this completed start performing the steps to use the trigger (as outlined in the link above), i.e. 

* create a keyspace in which all the magic will take place
```
CREATE KEYSPACE test WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : '1' };
```
* create a table inside the keyspace where the "audit trail" will be saved
```
CREATE TABLE test.audit (key timeuuid, keyspace_name text, table_name text, primary_key text, PRIMARY KEY(key));
```
* create a table wich will be using the trigger
```
CREATE TABLE test.test (key text, value text, PRIMARY KEY(key));
```
* create the triggger on this previously created table
```
CREATE TRIGGER test1 ON test.test USING 'org.apache.cassandra.triggers.AuditTrigger';
```
* insert some values in the table
```
INSERT INTO test.test (key, value) values ('1', '1');
INSERT INTO test.test (key, value) values ('2', '2');
INSERT INTO test.test (key, value) values ('3', '3');
```
* check the audit table
```
SELECT * FROM test.audit;
```

