sudo -H -u mongod mongod --enableEncryption --encryptionKeyFile /etc/certs/mongodb-keyfile --dbpath /var/lib/mongo --logpath /var/log/mongodb/mongod.log --bind_ip_all

