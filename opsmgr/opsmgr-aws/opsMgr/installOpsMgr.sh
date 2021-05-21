if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# OMFILE=mongodb-mms-4.4.1.101.20200805T0050Z-1.x86_64.rpm
# OMFILE=mongodb-mms-4.4.2.104.20200901T0504Z-1.x86_64.rpm
OMFILE=mongodb-mms-4.2.19.57005.20200925T1733Z-1.x86_64.rpm
OMFILEPATH=./$OMFILE
OMURL=https://downloads.mongodb.com/on-prem-mms/rpm/$OMFILE

if [ ! -f "$OMFILEPATH" ]; then
  echo "Ops Manager RPM not found locally."
  echo "Downloading Ops Manager RPM from MongoDB.com..."
  curl $OMURL --output $OMFILEPATH
fi

# STEP 2: Configure yum to install MongoDB
echo
echo Configuring Yum repo....
echo "[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/8/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc" | sudo tee /etc/yum.repos.d/mongodb.repo

# Ops Manager fails if these aren't in place, especially once you enable backups.
echo Increasing system limits for mongod user...
cp limits.conf /etc/security

# STEP 3: Install MongoDB
echo
echo Installing MongoDB...
yum install -y mongodb-org mongodb-org-shell

# Step 4: Disable the mongod service
systemctl disable mongod

# STEP 4: Create the OM AppDB directory
echo
echo Creating AppDB and Backup directories...
mkdir -p /data/appdb
mkdir -p /data/backup
chown -R mongod:mongod /data
mkdir /data/headdb
sudo chown mongodb-mms:mongodb-mms /data/headdb

# STEP 7: Start the OM AppDB Database mongod instance
echo
echo Starting MongoDB AppDB and BackupDB databases...
sudo -u mongod mongod --port 27017 --dbpath /data/appdb --logpath /data/appdb/mongodb.log --wiredTigerCacheSizeGB 1 --fork
sudo -u mongod mongod --port 27018 --dbpath /data/backup --logpath /data/backup/mongodb.log --wiredTigerCacheSizeGB 1 --fork

# STEP 10: Install Ops Manager
echo
echo Installing Ops Manager...
yum install -y $OMFILEPATH

echo
echo Copying config file...
sed "s/INTERNAL_HOSTNAME/$HOSTNAME/g" conf-mms.properties > /opt/mongodb/mms/conf/conf-mms.properties

# STEP 11: Start Ops Manager
echo
echo Starting Ops Manager...
service mongodb-mms start

echo
echo Creating HeadDB and File System Store directories...
mkdir /data/headdb
mkdir /data/filestore
sudo chown mongodb-mms:mongodb-mms /data/headdb
sudo chown mongodb-mms:mongodb-mms /data/filestore

echo
echo Downloading MongoDB versions...
./getVersions.sh

# Trick to get the public DNS of this server
PUBLIC_HOSTNAME="$(curl http://169.254.169.254/latest/meta-data/public-hostname 2>/dev/null)"

echo 
echo "Ops Manager installation complete."
echo "Access UI at http://$PUBLIC_HOSTNAME:8080"
echo "and create the initial user (i.e. register for new account)."

