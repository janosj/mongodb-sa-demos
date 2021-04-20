#!/bin/bash

# Provisions the specified number of EC2 instances
# to support the deployment of a Kubernetes cluster.

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root to update the /etc/hosts file."
   exit 1
fi

if [ -z "$1" ]; then
    echo "No argument supplied"
    echo "Usage: provisionK8sCluster.sh <k8s-node-count>"
    exit 1
fi

if [ "$1" -gt 9 ]; then
    echo "This script cannot deploy more than 9 K8s nodes currently."
    echo "To fix, modify the updateHosts script - currently the string matching will confuse k81 with k810."
    echo "Exiting."
    exit 1
fi

SCRIPT_LOC=$HOME/github/mongodb-sa-demos/kubernetes-operator/0-aws-scripts
export NODE_PATH=/usr/local/lib/node_modules

i="0"
while [ $i -lt $1 ]; do
  i=$[$i+1]
  echo 
  echo Provisioning agent$i...
  node $SCRIPT_LOC/provisionEC2Instance.js <awskeyfile> <sg-id> <subnet-id> project-k8$i <firstname.lastname> 20 t2.medium ami-000db10762d0c4c05 k8$i
done

echo 
echo Done.
echo

