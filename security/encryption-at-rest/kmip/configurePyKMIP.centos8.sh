INSTALL_DIR=/etc/pykmip
CERTS_LOC=/etc/pykmip/certs
LOG_LOC=/var/log/pykmip
CURRENT_DIR=$PWD

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo Installing python3 and pip3...
yum install -y python3 git

echo "Installing (cloning) PyKMIP..."

mkdir -p $INSTALL_DIR
rm -rf $INSTALL_DIR/*
cd $INSTALL_DIR
git clone https://github.com/OpenKMIP/PyKMIP.git

# For simplicity, virtualenv references removed from example scripts.
# all python dependencies installed globally.
cd PyKMIP
pip3 install -r requirements.txt
python3 setup.py install

cp .travis/pykmip.conf $INSTALL_DIR/pykmip.conf
sed -i 's/key.pem/server.key/g' $INSTALL_DIR/pykmip.conf
sed -i 's/cert.pem/server.crt/g' $INSTALL_DIR/pykmip.conf

cp .travis/server.conf $INSTALL_DIR/server.conf
sed -i 's/cert.pem/server.crt/g' $INSTALL_DIR/server.conf
sed -i 's/key.pem/server.key/g' $INSTALL_DIR/server.conf

# CentOS8 doesn't like Basic - leads to "unsupported protocol"
# See here: https://pykmip.readthedocs.io/en/latest/server.html
# This works on both CentOS and Ubuntu
sed -i 's/Basic/TLS1.2/g' $INSTALL_DIR/server.conf
sed -i 's/SSLv23/TLS/g' $INSTALL_DIR/pykmip.conf

mkdir -p $INSTALL_DIR/policies
cp .travis/policy.json $INSTALL_DIR/policies/policy.json

echo "Generating certs at $CERTS_LOC..."
mkdir -p $CERTS_LOC
cd $CERTS_LOC
openssl req -newkey rsa:2048 -nodes -keyout server.key -x509 -subj "/CN=localhost" -days 365 -out server.crt

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

