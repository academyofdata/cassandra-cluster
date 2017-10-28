# Running cassandra-stress with a user specified schema

```
cassandra-stress user profile=./stress.yaml no-warmup ops\(insert=1,pull-for-rollup=3,get-a-value=1\) n=100000 -rate threads=1 -node 172.17.0.8
```
