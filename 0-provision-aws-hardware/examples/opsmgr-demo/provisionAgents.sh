!/bin/bash

# Provisions the specified number of EC2 instances
# for MongoDB Agents..

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root to update the /etc/hosts file."
   exit 1
fi

if [ -z "$1" ]; then
    echo "No argument supplied"
    echo "Usage: provisionK8sCluster.sh <agent-node-count>"
    exit 1
fi

if [ "$1" -gt 9 ]; then
    echo "This script cannot deploy more than 9 agent nodes currently."
    echo "To fix, modify the updateHosts script - currently the string matching will confuse agent1 with agent10."
    echo "Exiting."
    exit 1
fi

SCRIPT_LOC=$HOME/github/mongodb-sa-demos/0-provision-aws-hardware
KEYFILE=<name-of-keyfile-no-extension>
SECURITY_GROUP=<security-group>
SUBNET=<subnet-xyz>
TAG_OWNER=firstname.lastname
ROOT_VOL_GB=10
INSTANCE_TYPE=t3.medium
IMAGE_ID=ami-098f16afa9edf40be   # RHEL 8.2
#IMAGE_ID=ami-00ddb0e5626798373  # Ubuntu 18.04

export NODE_PATH=/usr/local/lib/node_modules

# Usage:
# provisionEC2Instance.js keyName securityGroupID subnetID tagName tagOwner rootVolumeGB instanceType imageId etcHostname

i="0"
while [ $i -lt $1 ]; do
  i=$[$i+1]
  echo 
  echo Provisioning agent$i...
  node $SCRIPT_LOC/provisionEC2Instance.js $KEYFILE $SECURITY_GROUP $SUBNET <name>-agent$i $TAG_OWNER $ROOT_VOL_GB $INSTANCE_TYPE $IMAGE_ID agent$i

done

echo 
echo Done.
echo

