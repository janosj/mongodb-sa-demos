source demo.conf

if [ ! -d "$MDB_CONNECT_URI" ]; then
  echo "MongoDB Connect URI not set.."
  echo "Check that MDB_CONNECT_URI is set in demo.conf."
  echo "This is normally set by the install-kafka script."
  echo "Exiting."
  exit 1
fi

mongo $MDB_CONNECT_URI watchAlerts.js

