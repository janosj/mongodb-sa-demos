#!/usr/bin/env python3
  
from time import sleep
from json import dumps
from kafka import KafkaProducer
from kafka.errors import KafkaError


#producer = KafkaProducer(bootstrap_servers=['opsmgr:9092'], api_version=(0, 10, 2))

# Asynchronous by default
#future = producer.send('COVID_MAVERICK', b'raw_bytes')

# Block for 'synchronous' sends
#try:
#    record_metadata = future.get(timeout=10)
#except KafkaError:
    # Decide what to do if produce request failed...
#    print("ERROR")
#    pass

producer = KafkaProducer(bootstrap_servers=['localhost:9092'],
                         api_version=(0, 10, 2),
                         value_serializer=lambda x: dumps(x).encode('utf-8'))

#inputPath = "../../data/final-merged-dataset/"
inputPath = "./"
inputFileName = "allData-sorted.json"
inputFile = open(inputPath + inputFileName)

#load json from file
lines = []
while True:
    line = inputFile.readline()
    if not line: break
    line = line.strip()
    #json_obj = json.loads(line)
    #lines.append(json_obj)
    print(line + "\n")
    producer.send('COVID', value=line)
    producer.flush()
    sleep(0.8)

#data={'source':'JJ-MAC'}
#outputFile.write(json.dumps(line) + "\n")

print("Done. Reached end of input file.")
