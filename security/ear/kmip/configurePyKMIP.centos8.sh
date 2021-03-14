if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo Updating system.. this might take a while.
yum update -y –allowerasing

echo Installing python3 and pip3...
yum install -y python3 git
git clone https://github.com/OpenKMIP/PyKMIP.git

cd PyKMIP

# virtualenv references removed
# all python dependencies installed globally.
pip3 install -r requirements.txt
python3 setup.py install

echo Installing PyKMIP...

mkdir /etc/pykmip
cp ./.travis/pykmip.conf /etc/pykmip/pykmip.conf
sed -i 's/key.pem/server.key/g' /etc/pykmip/pykmip.conf
sed -i 's/cert.pem/server.crt/g' /etc/pykmip/pykmip.conf
# required to avoid SSL: UNSUPPORTED_PROTOCOL errors on CentOS (not Ubuntu)
sed -i 's/SSLv23/TLSv1/g' /etc/pykmip/pykmip.conf

cp ./.travis/server.conf /etc/pykmip/server.conf
sed -i 's/cert.pem/server.crt/g' /etc/pykmip/server.conf
sed -i 's/key.pem/server.key/g' /etc/pykmip/server.conf

mkdir /etc/pykmip/policies
cp ./.travis/policy.json /etc/pykmip/policies/policy.json

mkdir /etc/pykmip/certs
cd /etc/pykmip/certs
openssl req -newkey rsa:2048 -nodes -keyout server.key -x509 -subj "/CN=localhost" -days 365 -out server.crt

# Required by MongoDB, not by PyKMIP
cat server.crt server.key > server.pem

cd -

mkdir -p /var/log/pykmip
chmod 777 /var/log/pykmip

echo Finished PyKMIP setup.
echo

echo "To run the server (from <install-loc>/PyKMIP):"
echo "PYTHONPATH=. python3 bin/run_server.py"
echo
echo You can run a test client (in a separate window). 
echo "Also helpful to tail the log file in a 3rd (tail -f /var/log/pykmip/server.log)"
echo "From <install-loc>/PyKMIP:"
echo "PYTHONPATH=. python3 kmip/demos/pie/create.py -a AES -l 256"
echo

echo You can also test the certs themselves, outside of Mongo or PyKMIP.
echo "To run an openssl server: (from /etc/pkymip/certs)
echo "openssl s_server -accept 5696 -www -key server.key -cert server.crt"
echo "Note: no CAfile specified."
echo
echo "To run an openssl client: 
echo "openssl s_client -connect localhost:5696"
echo "Note: no CAfile specified."
echo "Also note: no protocol specified. Had to switch from SSLv23 to TLSv1.
echo "options included SSLv3 TLSv1 TLSv1.1 TLSv1.2. -tls1_2"

