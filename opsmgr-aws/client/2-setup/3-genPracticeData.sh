# 200k documents ~ 272MB
source ../conf/setEnv.sh

if [ -z "$MDB_CONNECT" ]
then
  echo "Environment not set. No MDB_CONNECT info."
  exit 1
fi

mgeneratejs CustomerSingleView.json -n 200000 | mongoimport --uri $MDB_CONNECT  --collection practiceRun
