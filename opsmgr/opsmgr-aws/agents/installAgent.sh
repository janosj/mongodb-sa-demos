if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo Installing OS dependencies...
sudo yum install -y cyrus-sasl cyrus-sasl-gssapi cyrus-sasl-plain krb5-libs libcurl lm_sensors-libs net-snmp net-snmp-agent-libs openldap openssl

echo Installing binutils, which contains strings for encryption at rest...
sudo yum install -y binutils

# Copy this URL from Ops Manager Donwload Agent settings.
echo Downloading agent...
curl -OL http://ip-172-31-60-215.ec2.internal:8080/download/agent/automation/mongodb-mms-automation-agent-manager-10.2.20.5992-1.x86_64.rhel7.rpm

# Copy this from Ops Manager Download Agent settings.
echo Installing agent...
sudo rpm -U mongodb-mms-automation-agent-manager-10.2.20.5992-1.x86_64.rhel7.rpm

#echo Installing MMS Agent Package...
#yum install -y $AGENTFILE

echo Copying config file...
cp ./automation-agent.config /etc/mongodb-mms
chown mongod:mongod /etc/mongodb-mms/automation-agent.config

# This setup provides a lot of flexibility. You don't have to use it, you can just use /data if you don't overlap components. 
echo Making data directories...
mkdir -p /data
mkdir -p /data/shards
mkdir -p /data/configRS
mkdir -p /data/mongos
mkdir -p /data2

chown -R mongod:mongod /data
chown -R mongod:mongod /data2

echo Starting agent...
systemctl start mongodb-mms-automation-agent.service

echo Configuring agent to start automatically on reboot...
chkconfig mongodb-mms-automation-agent on

