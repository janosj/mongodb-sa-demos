#!/bin/bash

# Provisions an EC2 instance to host MongoDB Ops Manager.
# (Ops Manager is not installed).

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root to update the /etc/hosts file."
   exit 1
fi

SCRIPT_LOC=$HOME/github/mongodb-sa-demos/0-provision-aws-hardware
KEYFILE=<keyfile-name-no-extension>
SECURITY_GROUP=<security-group-id>
SUBNET=<your-aws-subnet>
TAG_NAME=<lastname-opsmgr>
TAG_OWNER=firstname.lastname
ROOT_VOL_GB=30
INSTANCE_TYPE=m4.xlarge
IMAGE_ID=ami-098f16afa9edf40be    # RHEL 8.2
HOSTNAME_ENTRY=opsmgr

export NODE_PATH=/usr/local/lib/node_modules

# Usage:
# provisionOpsMgrInstance keyName securityGroupID subnetID tagName tagOwner rootVolumeGB instanceType imageId etcHostname

# ami-098f16afa9edf40be: RHEL 8.2
node $SCRIPT_LOC/provisionEC2Instance.js $KEYFILE $SECURITY_GROUP $SUBNET $TAG_NAME $TAG_OWNER $ROOT_VOL_GB $INSTANCE_TYPE $IMAGE_ID $HOSTNAME_ENTRY

