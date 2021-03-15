#!/bin/bash

INSTALL_DIR=/etc/pykmip/PyKMIP
DOCKER_NETWORK_IP=172.17.0.1

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

CONFIG_MODE=$1
if [[ -z "$CONFIG_MODE" ]]; then
  echo "Usage: testConnection.openSSL <local|docker>"
  echo "If running Docker, PyKMIP uses the Docker-specific network."
  echo "Otherwise, it's probably local."
  echo "Check the hostname setting in the pykmip server.conf file."
  echo "The client needs to connect to that same hostname setting."
  exit
fi

if [[ $CONFIG_MODE = "local" ]]; then
  PYKMIP_SERVER=127.0.0.1
elif [[ $CONFIG_MODE = "docker" ]]; then
  PYKMIP_SERVER=$DOCKER_NETWORK_IP
else 
  echo "Unrecognized config mode: $CONFIG_MODE. Exiting. Run without options for help."
  exit
fi

echo Sending test request ...
openssl s_client -connect $PYKMIP_SERVER:5696 -cert /etc/pykmip/certs/server.pem -CAfile /etc/pykmip/certs/server.crt

