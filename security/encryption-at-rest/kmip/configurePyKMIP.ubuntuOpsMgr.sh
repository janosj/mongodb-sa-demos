#!/bin/bash

INSTALL_DIR=/etc/pykmip
CURRENT_DIR=$PWD

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo Updating system.. this might take a while.
apt update -y
apt upgrade -y
apt autoremove -y

echo Installing python3 and pip3...
apt install -y python3 git

echo "Installing (cloning) PyKMIP..."

mkdir -p $INSTALL_DIR
rm -rf $INSTALL_DIR/*
cd $INSTALL_DIR
git clone https://github.com/OpenKMIP/PyKMIP.git

# virtualenv references removed
# all python dependencies installed globally.
cd PyKMIP
pip3 install -r requirements.txt
python3 setup.py install

cp .travis/pykmip.conf /etc/pykmip/pykmip.conf
sed -i 's/key.pem/server.key/g' /etc/pykmip/pykmip.conf
sed -i 's/cert.pem/server.crt/g' /etc/pykmip/pykmip.conf
# required to avoid SSL: UNSUPPORTED_PROTOCOL errors on CentOS (not Ubuntu)
sed -i 's/SSLv23/TLSv1/g' /etc/pykmip/pykmip.conf

cp .travis/server.conf /etc/pykmip/server.conf
sed -i 's/cert.pem/server.crt/g' /etc/pykmip/server.conf
sed -i 's/key.pem/server.key/g' /etc/pykmip/server.conf

# This is the service binding. 
# You can't specify 'opsmgr' here, you have to specify the IP address
# that is accessible by the Docker containers. The opsmgr host binds
# to multiple networks - if the PyKMIP server binds to 'opsmgr' it will
# not be on the Docker nework, and network connections from clients will
# be refused before the SSL negotiation can start.
# Note the client config has to match the server config.
sed -i 's/127.0.0.1/172.17.0.1/g' /etc/pykmip/server.conf
sed -i 's/127.0.0.1/172.17.0.1/g' /etc/pykmip/pykmip.conf

mkdir -p /etc/pykmip/policies
cp .travis/policy.json /etc/pykmip/policies/policy.json

echo "Generating certs at /etc/pykmip/certs..."
mkdir -p /etc/pykmip/certs
cd /etc/pykmip/certs
openssl req -newkey rsa:2048 -nodes -keyout server.key -x509 -subj "/CN=opsmgr" -days 365 -out server.crt

# Required by MongoDB, not by PyKMIP
cat server.crt server.key > server.pem

echo "Log directory is /var/log/pykmip..."
mkdir -p /var/log/pykmip
chmod 777 /var/log/pykmip

cd $CURRENT_DIR

echo
echo "**** Finished PyKMIP setup. ****"
echo

echo "To run the server (from <install-loc>/PyKMIP):"
echo "PYTHONPATH=. python3 bin/run_server.py"
echo
echo "To run a test client in a separate window (from <install-loc>/PyKMIP):"
echo "(it can be helpful tailing the log file: tail -f /var/log/pykmip/server.log"
echo "PYTHONPATH=. python3 kmip/demos/pie/create.py -a AES -l 256"
echo

echo "You can also test the certs via openssl, outside of Mongo or PyKMIP."
echo "To run an openssl server (from /etc/pkymip/certs):"
echo "openssl s_server -accept 5696 -www -key server.key -cert server.crt"
echo "Note: no CAfile specified."
echo
echo "To run an openssl client:"
echo "openssl s_client -connect localhost:5696"
echo "Note: no CAfile specified."
echo "Also note: no protocol specified. Had to switch from SSLv23 to TLSv1."
echo "options included SSLv3 TLSv1 TLSv1.1 TLSv1.2. -tls1_2"

