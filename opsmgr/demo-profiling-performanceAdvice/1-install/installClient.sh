# Check for sudo user.
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
yum install -y nodejs
npm install -g mgeneratejs
# Note: this is the new mongosh that replaces the original mongo shell.
yum install -y https://downloads.mongodb.com/compass/mongodb-mongosh-0.13.2.el7.x86_64.rpm
yum install -y https://fastdl.mongodb.org/tools/db/mongodb-database-tools-rhel80-x86_64-100.3.1.rpm

