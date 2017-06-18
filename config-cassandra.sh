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
echo "this script will remove all your existing cassandra data."

echo "stopping cassandra "
sudo service cassandra stop

echo "changing cluster name"
sudo sed -i -e 's/Test Cluster/CassandraTraining/g' /etc/cassandra/cassandra.yaml

echo "changing listen_address to $IPADDR"
sudo sed -i -e "s/listen_address: localhost/listen_address: $IPADDR/g" /etc/cassandra/cassandra.yaml

echo "changing seed address to $SEEDIP"
sudo sed -i -e "s/127\.0\.0\.1/$SEEDIP/g" /etc/cassandra/cassandra.yaml

echo "changing rpc_address to $IPADDR"
sudo sed -i -e "s/rpc_address: localhost/rpc_address: $IPADDR/g" /etc/cassandra/cassandra.yaml

echo "removing old files"
sudo rm -rf /var/lib/cassandra/* /var/log/cassandra/*

echo "starting cassandra"
sudo service cassandra start

echo "changing CQLSH_HOST variable"
echo "export CQLSH_HOST=$IPADDR" | sudo tee -a /etc/profile

if [ $# -eq 3 ]
  then
    echo "we have a third parameter, enabling user '$3'"
    echo "enabling Password Login"
    sudo sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

    echo "reloading sshd"
    sudo /etc/init.d/ssh reload

    echo "adding user '$3'"
    sudo adduser $3 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password

    PASSWD=`openssl rand -base64 8`
    echo "setting user password to: $PASSWD"
    echo "$3:$PASSWD" | sudo chpasswd

    echo "adding user to sudo group"
    sudo usermod -G adm,sudo,$3 $3
fi
