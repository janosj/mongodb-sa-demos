echo THIS SCRIPT ERASES ANY EXISTING DATABASE AT /var/lib/mongo.
read -rsp $'Press any key to acknowledge and continue...\n' -n1 key

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo Creating location for certs at /etc/certs
rm -rf /etc/certs
mkdir /etc/certs
chown mongod:mongod /etc/certs
chmod 700 /etc/certs

echo Generating certs
cd /etc/certs
openssl rand -base64 32 > mongodb-keyfile
chown mongod:mongod mongodb-keyfile
chmod 600 mongodb-keyfile

echo "Shutting down mongod and removing any pre-existing (unencrypted) data"
systemctl stop mongod
rm -rf /var/lib/mongo/*
rm -rf /var/log/mongodb/*

echo
echo Configuration of Encryption at Rest completed.
echo

echo To launch mongod with proper command-line options.
echo Storage options included. 
echo Runs as mongod:
echo sudo -H -u mongod mongod --enableEncryption --encryptionKeyFile /etc/certs/mongodb-keyfile --dbpath /var/lib/mongo --logpath /var/log/mongodb/mongod.log --bind_ip_all

