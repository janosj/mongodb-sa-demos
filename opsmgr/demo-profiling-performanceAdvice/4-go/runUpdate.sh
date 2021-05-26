source ../conf/demo.conf

if [ -z "$MDB_CONNECT" ]
then
  echo "Environment not set. No MDB_CONNECT info."
  exit 1
fi

echo "Env MDB_CONNECT set to $MDB_CONNECT"
exit 1

mongo --retryWrites $MDB_CONNECT functions/updateInsInfo.js

