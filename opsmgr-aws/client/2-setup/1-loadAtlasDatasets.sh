source ../conf/setEnv.sh

if [ -z "$MDB_CONNECT" ]
then
  echo "Environment not set. No MDB_CONNECT info."
  exit 1
fi

mongorestore --uri="$MDB_CONNECT" --nsInclude=sample_airbnb.listingsAndReviews --nsInclude=sample_training.grades --nsInclude=sample_mflix.movies --nsInclude=sample_weatherdata.data ./atlas-sample-data-sets/dump
