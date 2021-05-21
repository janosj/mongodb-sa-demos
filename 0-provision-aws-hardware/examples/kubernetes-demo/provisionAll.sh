#!/bin/bash

# Provisions an Ops Manager instance and
# the specified number of Kubernetes nodes

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root to update the /etc/hosts file."
   exit 1
fi

if [ -z "$1" ]; then
    echo "No argument supplied"
    echo "Usage: provisionAll.sh <k8s-node-count>"
    exit 1
fi

./provisionOpsMgrHardware.sh

./provisionK8sCluster.sh $1
