PROJECT="project-name-here"
ZONE="europe-west1-d"
MACHINE="g1-small"

gcloud compute instances create "csnd1" --zone $ZONE --machine-type $MACHINE --network "default"  --maintenance-policy "MIGRATE" --scopes default="https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --image "/ubuntu-os-cloud/ubuntu-1604-xenial-v20161205" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "csnd1d1" --project $PROJECT

echo "waiting for the machine to come up"
sleep 30

gcloud compute ssh --project $PROJECT "csnd1" --zone $ZONE --command "wget -qO- https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/setup39.sh | bash" 

IPADDR=`gcloud compute instances list --project $PROJECT --format=text | grep '^networkInterfaces\[[0-9]\+\]\.networkIP:' | sed 's/^.* //g'`


echo "Host internal address is $IPADDR"
echo "stopping cassandra "
gcloud compute ssh --project $PROJECT --zone $ZONE "csnd1" --command "sudo service cassandra stop"

echo "changing cluster name"
gcloud compute ssh --project $PROJECT --zone $ZONE "csnd1" --command "sudo sed -i -e 's/Test Cluster/CassandraTraining/g' /etc/cassandra/cassandra.yaml"

echo "changing listen_address"
gcloud compute ssh --project $PROJECT --zone $ZONE "csnd1" --command "sudo sed -i -e 's/listen_address: localhost/listen_address: $IPADDR/g' /etc/cassandra/cassandra.yaml"

echo "changing seed address"
gcloud compute ssh --project $PROJECT --zone $ZONE "csnd1" --command "sudo sed -i -e 's/127\.0\.0\.1/$IPADDR/g' /etc/cassandra/cassandra.yaml"

echo "changing rpc_address"
gcloud compute ssh --project $PROJECT --zone $ZONE "csnd1" --command "sudo sed -i -e 's/rpc_address: localhost/rpc_address: $IPADDR/g' /etc/cassandra/cassandra.yaml"

echo "removing old files"
gcloud compute ssh --project $PROJECT --zone $ZONE "csnd1" --command "sudo rm -rf /var/lib/cassandra/* /var/log/cassandra/*"

echo "starting cassandra"
gcloud compute ssh --project $PROJECT --zone $ZONE "csnd1" --command "sudo service cassandra start"

echo "adding CQLSH_HOST to profile"
gcloud compute ssh --project $PROJECT --zone $ZONE "csnd1" --command "echo 'export CQLSH_HOST=$IPADDR' | sudo tee -a /etc/profile"

echo "enabling Password Login"
gcloud compute ssh --project $PROJECT --zone $ZONE "csnd1" --command "sudo sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config"

echo "reloading sshd"
gcloud compute ssh --project $PROJECT --zone $ZONE "csnd1" --command "sudo /etc/init.d/ssh reload"

echo "adding user"
gcloud compute ssh --project $PROJECT --zone $ZONE "csnd1" --command "sudo adduser cuser --gecos \"First Last,RoomNumber,WorkPhone,HomePhone\" --disabled-password"

PASSWD=`openssl rand -base64 8`
echo "setting user password to: $PASSWD"
gcloud compute ssh --project $PROJECT --zone $ZONE "csnd1" --command "echo \"cuser:$PASSWD\" | sudo chpasswd"

echo "changing user groups"
gcloud compute ssh --project $PROJECT --zone $ZONE "csnd1" --command "sudo usermod -G adm,sudo,cuser cuser"

