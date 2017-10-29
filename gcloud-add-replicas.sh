MACHINE="n1-standard-1"
ZONE="europe-west1-d"
NODE="node02"

if [ $# -ge 1 ]
then
        NODE=$1
fi

echo "using ${NODE} as instance name"

if [ $# -ge 2 ]
then
        SEED=$2
else
        echo "looking for a running instance that has 'cassandra-seed' label set to 'true'"
        SEED=$(gcloud compute instances list --filter="labels.cassandra-seed=true" --format="value(name)")
fi

echo "using ${SEED} as seed instance name"

gcloud compute instances create ${NODE} --zone ${ZONE} --machine-type ${MACHINE} --maintenance-policy "MIGRATE" --image "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts" --boot-disk-size "20" --boot-disk-type "pd-standard" --boot-disk-device-name "${NODE}disk"

echo "waiting for the machine to come up"
sleep 30

gcloud compute ssh $NODE --zone $ZONE --command "wget -qO- https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/setup39.sh | bash"

IPADDR=$(gcloud compute instances list --filter="name=${NODE}" --format="value(networkInterfaces[0].networkIP)")
SEEDIP=$(gcloud compute instances list --filter="name=${SEED}" --format="value(networkInterfaces[0].networkIP)")

echo "configuring cassandra after installation with $IPADDR and seed $SEEDIP"
gcloud compute ssh $NODE --zone $ZONE --command "wget -qO- https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/config-cassandra.sh | bash -s $IPADDR $SEEDIP"

gcloud compute instances add-labels ${NODE} --zone ${ZONE} --labels=cassandra-cluster-name=cassandra-training
