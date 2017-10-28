# Running cassandra-stress with a user specified schema

First make sure that you have a test profile similar with the one at https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/stress-tool.yaml

You can adjust the keyspace definition, table definitions and column specs according to your particular need. Once the appropriate version is saved you can simply run

```
cassandra-stress user profile=./stress.yaml no-warmup ops\(insert=1,pull-for-rollup=3,get-a-value=1\) n=100000 -rate threads=1 -node 172.17.0.8
```
