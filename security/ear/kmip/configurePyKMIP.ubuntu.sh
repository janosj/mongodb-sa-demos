if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# This takes a long time.
# sudo apt update
# sudo apt upgrade
# sudo apt autoremove

# Dockerfile also has these:
# apt-get autoremove
# apt-get autoclean
# apt-get clean

apt install -y python3 git
git clone https://github.com/OpenKMIP/PyKMIP.git

cd PyKMIP

# virtualenv references removed
# all python dependencies installed globally.
pip3 install -r requirements.txt
python3 setup.py install

mkdir /etc/pykmip
cp ./.travis/pykmip.conf /etc/pykmip/pykmip.conf
sed -i 's/key.pem/server.key/g' /etc/pykmip/pykmip.conf
sed -i 's/cert.pem/server.crt/g' /etc/pykmip/pykmip.conf
# required to avoid SSL: UNSUPPORTED_PROTOCOL errors on CentOS (not Ubuntu)
#sed -i 's/SSLv23/TLSv1/g' /etc/pykmip/pykmip.conf

cp ./.travis/server.conf /etc/pykmip/server.conf
sed -i 's/cert.pem/server.crt/g' /etc/pykmip/server.conf
sed -i 's/key.pem/server.key/g' /etc/pykmip/server.conf

# You can't specify 'opsmgr' here, you have to specify the IP address
# that is accessible by the Docker containers. The opsmgr host binds
# to multiple networks - if the PyKMIP server binds to 'opsmgr' it will
# not be on the Docker nework, and network connections from clients will
# be refused before the SSL negoitation can start.  
sed -i 's/127.0.0.1/172.17.0.1/g' /etc/pykmip/server.conf

mkdir /etc/pykmip/policies
cp ./.travis/policy.json /etc/pykmip/policies/policy.json

mkdir /etc/pykmip/certs
cd /etc/pykmip/certs
# Required on Ubuntu after the system upgrade upgraded openssl.
# This solves "can't load random.rnd into RNG"
# sudo openssl rand -out /root/.rnd -hex 256
# That wasn't working anymore.
# Now trying this:
# Comment out RANDFILE = $ENV::HOME/.rnd from /etc/ssl/openssl.cnf 
openssl req -newkey rsa:2048 -nodes -keyout server.key -x509 -subj "/CN=opsmgr" -days 365 -out server.crt

# Required by MongoDB, not by PyKMIP
cat server.crt server.key > server.pem

cd -

mkdir -p /var/log/pykmip
chmod 777 /var/log/pykmip

###########################################################

# Run the server until Ctrl-C. 
# From <install-loc>/PyKMIP:
# PYTHONPATH=. python3 bin/run_server.py

# You can run a test client (in a separate window). 
# Also helpful to tail the log file in a 3rd (tail -f /var/log/pykmip/server.log)
# From <install-loc>/PyKMIP:
# PYTHONPATH=. python3 kmip/demos/pie/create.py -a AES -l 256

###########################################################

# You can also test the certs themselves, outside of Mongo or PyKMIP.

# server. Note: no CAfile specified.
# run this from /etc/pkymip/certs
# openssl s_server -accept 5696 -www -key server.key -cert server.crt

# client. Note: no CAfile specified.
# Also note: no protocol specified. Had to switch from SSLv23 to TLSv1.
# options included SSLv3 TLSv1 TLSv1.1 TLSv1.2. -tls1_2
# openssl s_client -connect localhost:5696

