#!/bin/bash

# Provisions an EC2 instance to host MongoDB Ops Manager.
# (Ops Manager is not installed).

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root to update the /etc/hosts file."
   exit 1
fi

SCRIPT_LOC=$HOME/github/mongodb-sa-demos/kubernetes-operator/0-aws-scripts

export NODE_PATH=/usr/local/lib/node_modules

# Usage:
# provisionOpsMgrInstance keyName securityGroupID subnetID tagName tagOwner rootVolumeGB instanceType imageId etcHostname

node $SCRIPT_LOC/provisionEC2Instance.js <awskeyfile> <sg-id> <subnet-id> project-opsmgr <firstname.lastname> 20 t2.medium ami-098f16afa9edf40be opsmgr
