#!/bin/bash
#example for cassandra triggers as explained here https://github.com/apache/cassandra/tree/trunk/examples/triggers
sudo wget -O /etc/cassandra/triggers/trigger-example.jar https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/bin/trigger-example.jar
if [ ! -d "/etc/cassandra/conf/" ]; then
        sudo mkdir /etc/cassandra/conf/
fi
sudo wget -O /etc/cassandra/conf/AuditTrigger.properties https://raw.githubusercontent.com/apache/cassandra/trunk/examples/triggers/conf/AuditTrigger.properties 
echo "Reloading triggers..."
nodetool reloadtriggers
