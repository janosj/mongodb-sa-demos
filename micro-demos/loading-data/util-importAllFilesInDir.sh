#!/bin/bash
FILES=./zeus/*
for f in $FILES
do
  echo "Processing $f file..."
  mongoimport --host "myserver1" --port "27021" --db=test1 --collection=zeus1 --type=json --file=$f
done

