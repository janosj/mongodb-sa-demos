INSTALL_DIR=/etc/pykmip/PyKMIP

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo Looking for PyKMIP server in $INSTALL_DIR ...
echo Sending test request ...
PYTHONPATH=. python3 $INSTALL_DIR/kmip/demos/pie/create.py -a AES -l 256

