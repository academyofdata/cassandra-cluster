# Running cassandra-stress with a user specified schema

First make sure that you have a test profile similar with the one at https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/stress-tool.yaml

You can adjust the keyspace definition, table definitions and column specs according to your particular need. Once the appropriate version is saved you can simply run

```
cassandra-stress user profile=./stress-tool.yaml no-warmup ops\(insert=1,pull-for-rollup=3,get-a-value=1\) n=100000 -rate threads=1 -node <one-cluster-node-ip-here>
```

To make sure that the test is run against a 'fresh' keyspace (they won't be recreated on subsequent runs, except when explicitly dropping them), use the stress.sh script as follows (you can download/edit the number of iterations, concurrent threads and other params)

```
wget -qO- https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/stress.sh | bash
```

See a detailed description of the arguments passed to cassandra-stress at https://docs.datastax.com/en/cassandra/3.0/cassandra/tools/toolsCStress.html
