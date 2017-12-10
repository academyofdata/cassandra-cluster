ZONE="europe-west1-d"
MACHINE="n1-standard-2"
NODE="node01"

if [ $# -ge 1 ]
then
        NODE=$1
fi

echo "using ${NODE} as instance name"

gcloud compute instances create ${NODE} --zone ${ZONE} --machine-type ${MACHINE} --maintenance-policy "MIGRATE" --image "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts" --boot-disk-size "50" --boot-disk-type "pd-standard" --boot-disk-device-name "${NODE}disk" --labels "cassandra-seed=true"
echo "waiting for the machine to come up"
sleep 30

echo "installing cassandra on remote node"
gcloud compute ssh ${NODE} --zone ${ZONE} --command "wget -qO- https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/setup39.sh | bash"

echo "finding internal address of the node"
IPADDR=$(gcloud compute instances list --filter="name=${NODE}" --format="value(networkInterfaces[0].networkIP)")

echo "IP is ${IPADDR}"

echo "configuring cassandra after installation"
gcloud compute ssh ${NODE} --zone ${ZONE} --command "wget -qO- https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/config-cassandra.sh | bash -s $IPADDR $IPADDR cuser"

#config-cassandra.sh replaces the default cluster name with CassandraTraining, so tag that in a label
gcloud compute instances add-labels ${NODE} --zone ${ZONE} --labels=cassandra-cluster-name=cassandra-training

#get the sample data
gcloud compute ssh ${NODE} --zone ${ZONE} --command "wget -qO- https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/get-data.sh | bash"
