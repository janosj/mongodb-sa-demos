#!/bin/bash
# Installs PyKMIP server on Ubuntu,
# specifically the Ubuntu server that is the Ops Manager demo VM.
# That VM relies on Docker to run multiple nodes.
# The PyKMIP service needs to be reachable from these Docker containers.
# Sets the hostname in the server.conf to the Docker IP address accordingly.

INSTALL_DIR=/etc/pykmip
DOCKER_NETWORK_IP=172.17.0.1
CERTS_LOC=/etc/pykmip/certs
LOG_LOC=/var/log/pykmip
CURRENT_DIR=$PWD

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo Installing python3 and pip3...
apt install -y python3 git

echo "Installing (cloning) PyKMIP..."

mkdir -p $INSTALL_DIR
rm -rf $INSTALL_DIR/*
cd $INSTALL_DIR
git clone https://github.com/OpenKMIP/PyKMIP.git

# For simplicity, virtualenv references removed from example scripts.
# All python dependencies installed globally.
cd PyKMIP
pip3 install -r requirements.txt
python3 setup.py install

cp .travis/pykmip.conf $INSTALL_DIR/pykmip.conf
sed -i 's/key.pem/server.key/g' $INSTALL_DIR/pykmip.conf
sed -i 's/cert.pem/server.crt/g' $INSTALL_DIR/pykmip.conf
# required to avoid SSL: UNSUPPORTED_PROTOCOL errors on CentOS (not Ubuntu)
sed -i 's/SSLv23/TLSv1/g' $INSTALL_DIR/pykmip.conf

cp .travis/server.conf $INSTALL_DIR/server.conf
sed -i 's/cert.pem/server.crt/g' $INSTALL_DIR/server.conf
sed -i 's/key.pem/server.key/g' $INSTALL_DIR/server.conf

# This is the service binding. 
# You can't specify 'opsmgr' here, you have to specify the IP address
# that is accessible by the Docker containers. The opsmgr host binds
# to multiple networks - if the PyKMIP server binds to 'opsmgr' it will
# not be on the Docker nework, and network connections from clients will
# be refused before the SSL negotiation can start.
# Note the client config has to match the server config.
sed -i "s/127.0.0.1/$DOCKER_NETWORK_IP/g" $INSTALL_DIR/server.conf
sed -i "s/127.0.0.1/$DOCKER_NETWORK_IP/g" $INSTALL_DIR/pykmip.conf

mkdir -p /etc/pykmip/policies
cp .travis/policy.json $INSTALL_DIR/policies/policy.json

echo "Generating certs at $CERTS_LOC..."
mkdir -p $CERTS_LOC
cd $CERTS_LOC
openssl req -newkey rsa:2048 -nodes -keyout server.key -x509 -subj "/CN=opsmgr" -days 365 -out server.crt

# Required by MongoDB, not by PyKMIP
cat server.crt server.key > server.pem

echo "Log directory is $LOG_LOC..."
mkdir -p $LOG_LOC
chmod 777 $LOG_LOC

cd $CURRENT_DIR

echo
echo "**** Finished PyKMIP setup. ****"
echo "Configuration files can be found at $INSTALL_DIR."
echo "Certs can be found at $CERTS_LOC."
echo "Server logs can be found at $LOG_LOC."
echo

