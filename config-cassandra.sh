if [ $# -eq 0 ]
  then
    IPADDR=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`
  else
    IPADDR=$1
fi

if [ $# -eq 2 ]
  then
    SEEDIP=$2
  else
    SEEDIP=$IPADDR
fi

echo "Using address $IPADDR with seed $SEEDIP"
exit
echo "stopping cassandra "
sudo service cassandra stop

echo "changing cluster name"
sudo sed -i -e 's/Test Cluster/CassandraTraining/g' /etc/cassandra/cassandra.yaml

echo "changing listen_address"
sudo sed -i -e 's/listen_address: localhost/listen_address: $IPADDR/g' /etc/cassandra/cassandra.yaml

echo "changing seed address"
sudo sed -i -e 's/127\.0\.0\.1/$SEEDIP/g' /etc/cassandra/cassandra.yaml

echo "changing rpc_address"
sudo sed -i -e 's/rpc_address: localhost/rpc_address: $IPADDR/g' /etc/cassandra/cassandra.yaml

echo "removing old files"
sudo rm -rf /var/lib/cassandra/* /var/log/cassandra/*

echo "starting cassandra"
sudo service cassandra start

echo "changing CQLSH_HOST variable"
echo "export CQLSH_HOST=$IPADDR" | sudo tee -a /etc/profile