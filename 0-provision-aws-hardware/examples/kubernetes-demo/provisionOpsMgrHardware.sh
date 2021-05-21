#!/bin/bash

# Provisions an EC2 instance to host MongoDB Ops Manager.
# Note: Ops Manager itself is not installed.
#       You can find an Ops Manager installation script in the opsmgr-aws demo.

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root to update the /etc/hosts file."
   exit 1
fi

SCRIPT_LOC=$HOME/github/mongodb-sa-demos/0-provision-aws-hardware

export NODE_PATH=/usr/local/lib/node_modules

# Usage:
# provisionOpsMgrInstance keyName securityGroupID subnetID tagName tagOwner rootVolumeGB instanceType imageId etcHostname

node $SCRIPT_LOC/provisionEC2Instance.js <awskeyfile> <sg-id> <subnet-id> project-opsmgr <firstname.lastname> 30 m4.xlarge ami-098f16afa9edf40be opsmgr
