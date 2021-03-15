#!/bin/bash

INSTALL_DIR=/etc/pykmip/PyKMIP

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Docker network IP is reachable from both 
# Ops Manager host as well as Docker containers.
DOCKER_NETWORK_IP=172.17.0.1
echo Sending test request ...
openssl s_client -connect $DOCKER_NETWORK_IP:5696 -cert /etc/pykmip/certs/server.pem -CAfile /etc/pykmip/certs/server.crt

