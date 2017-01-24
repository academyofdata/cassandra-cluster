PROJECT="project-id-here"
ZONE="europe-west1-d"
MACHINE="g1-small"
NODE="cass1"

if [ $# -ge 1 ]
then
	NODE=$1
fi

echo "using ${NODE} as instance name"

gcloud compute instances create $NODE --zone $ZONE --machine-type $MACHINE --network "default"  --maintenance-policy "MIGRATE" --scopes default="https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --image "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "${NODE}disk1" --project $PROJECT

echo "waiting for the machine to come up"
sleep 30

echo "installing cassandra on remote node"
gcloud compute ssh --project $PROJECT $NODE --zone $ZONE --command "wget -qO- https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/setup39.sh | bash"

IPADDR=`gcloud compute instances list --project $PROJECT --format=text $NODE | grep '^networkInterfaces\[[0-9]\+\]\.networkIP:' | sed 's/^.* //g'`

echo "configuring cassandra after installation"
gcloud compute ssh --project $PROJECT $NODE --zone $ZONE --command "wget -qO- https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/config-cassandra.sh | bash -s $IPADDR $IPADDR cuser"
