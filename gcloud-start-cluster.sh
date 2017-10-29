#!/bin/bash
echo -n "How many nodes? "
read numnodes
if ! [ "$numnodes" -eq "$numnodes" ] 2> /dev/null
then
    echo "Please enter an integer next time"
    exit
fi
SDIR=$(dirname $0)
$SDIR/gcloud-server-setup.sh node01
for ((i=2;i<=$numnodes;i++))
do
        echo "starting node0$i"
        $SDIR/gcloud-add-replicas.sh node0$i
done
