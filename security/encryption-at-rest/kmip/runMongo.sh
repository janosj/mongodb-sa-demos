# Prerequisite: configurePyKMIP.sh

mongod --port 27017 --dbpath /var/lib/mongo \
  --enableEncryption --kmipServerName localhost \
  --kmipPort 5696 --kmipServerCAFile /etc/pykmip/certs/server.pem \
  --kmipClientCertificateFile /etc/pykmip/certs/server.pem

