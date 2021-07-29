#!/bin/bash

# Transfers fully configured  agent config files to the specified number of agent instances.
# Required information includes:
#   mmsGroupId: goes in the automation-agent.config file
#   mmsApiKey : goes in the automation-agent.config file
#   mmsBaseUrl: goes in both the aa.config file and the install.sh file
#
# You can do this on each agent node before installing the agent, which gets cumbersome.
# Or, using this script, just do it once on your laptop, and transfer the fully-configured 
# files to all agents.

if [ -z "$1" ]; then
    echo "No argument supplied"
    echo "Usage: transferAgentConfigFiles.sh <agent-node-count>"
    exit 1
fi

# Your AWS key is required to access the instances.
read -p "Name of AWS keyfile (no extension): " KEYFILE

read -p "mmsGroupId: " MMSGROUPID
read -p "mmsApiKey: " MMSAPIKEY
read -p "mmsBaseUrl (including protocol and port): " MMSBASEURL

# Replace "/" with "\/" so that sed handles it properly.
MMSBASEURL_ESCAPE="${MMSBASEURL////\/}"

# Modify the files with the supplied information
sed "s/REPLACE_MMSGROUPID/$MMSGROUPID/g" automation-agent.config > automation-agent.config.1.tmp
sed "s/REPLACE_MMSAPIKEY/$MMSAPIKEY/g" automation-agent.config.1.tmp > automation-agent.config.2.tmp
sed "s/REPLACE_MMSBASEURL/$MMSBASEURL_ESCAPE/g" automation-agent.config.2.tmp > automation-agent.config.3.tmp
sed "s/REPLACE_MMSBASEURL/$MMSBASEURL_ESCAPE/g" install-agent.sh > install-agent.sh.tmp
chmod +x install-agent.sh.tmp

echo "Pulling cert from opsmgr-aws..."
scp -i $HOME/Keys/$KEYFILE.pem ec2-user@opsmgr-aws:./opsmgrCA.pem . 

# Transfer the completed files to all agents.
i="0"
while [ $i -lt $1 ]; do

  i=$[$i+1]
  echo 
  echo Transfering files to agent$i...

  scp -i $HOME/Keys/$KEYFILE.pem ./automation-agent.config.3.tmp ec2-user@agent$i:./automation-agent.config
  scp -i $HOME/Keys/$KEYFILE.pem ./install-agent.sh.tmp ec2-user@agent$i:./install-agent.sh
  scp -i $HOME/Keys/$KEYFILE.pem ./opsmgrCA.pem ec2-user@agent$i:.

done

echo "Deleting tmp files..."
rm *.tmp

echo 
echo Done.
echo
echo "Server cert is in local directory."
echo "Import it via Keychain Access (Mac utility, drag and drop into login section)"
echo "Double-click on it, switch Trust to 'Always Trust'"

