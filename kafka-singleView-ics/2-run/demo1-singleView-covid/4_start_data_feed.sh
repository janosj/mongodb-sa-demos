#!/usr/bin/env python3
  
from time import sleep
from json import dumps
from kafka import KafkaProducer
from kafka.errors import KafkaError

producer = KafkaProducer(bootstrap_servers=['localhost:9092'],
                         api_version=(0, 10, 2),
                         value_serializer=lambda x: dumps(x).encode('utf-8'))

inputPath = "./"
inputFileName = "allData-sorted.json"
inputFile = open(inputPath + inputFileName)

#load json from file
lines = []
while True:
    line = inputFile.readline()
    if not line: break
    line = line.strip()
    print(line + "\n")
    producer.send('COVID', value=line)
    producer.flush()
    sleep(0.8)

print("Done. Reached end of input file.")

