#!/bin/bash

# This is used to copy the strings utility to container 2
# for demonstrating encryption at rest. 

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [ -z "$1" ]; then
  echo "Usage: copy_strings_util <container ID>"
  echo "Use 'sudo docker ps -a' and look at container 2"
  exit 1
fi

docker cp arm-none-eabi-strings $1:/usr/bin/arm-none-eabi-strings

echo "Done!"
echo "Now ssh to container:"
echo "sudo docker exec -it $1 /bin/bash"

