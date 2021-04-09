# Check for sudo user.
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

#wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

yum install -y wget

# Download manually
# wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

yum install -y ./epel-release-latest-*.noarch.rpm

yum install -y nodejs
npm install -g mgeneratejs

yum install -y ./mongodb-enterprise-shell-4.2.5-1.el7.x86_64.rpm
yum install -y ./mongodb-enterprise-tools-4.2.5-1.el7.x86_64.rpm

