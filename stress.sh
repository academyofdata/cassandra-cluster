#!/bin/bash
SESSID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
echo "session id is: $SESSID"
sed "s/stressexample/stressexample_${SESSID}/g" ./stress-tool.yaml > stress-${SESSID}.yaml
#take the first node as reported by nodetool
CNODE=$(nodetool status | grep "^UN" | head -1 | awk '{print $2}')
echo "Running stress test against $CNODE"
cassandra-stress user profile=./stress-${SESSID}.yaml no-warmup ops\(insert=1,pull-for-rollup=3,get-a-value=1\) n=100000 -rate threads=1 -node $CNODE
