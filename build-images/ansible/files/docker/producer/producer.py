import os
import json
import time
from kafka import KafkaProducer, TopicPartition
from kafka.partitioner import RoundRobinPartitioner

brokers = os.environ['BROKERS']
topics = os.environ['TOPIC']
delay = float(os.environ.get('DELAY','0.0'))

# given that numtest `numtest` has at least 8 partitions
partitioner = RoundRobinPartitioner(partitions=[
    TopicPartition(topic=topics, partition=0),
    TopicPartition(topic=topics, partition=1),
    TopicPartition(topic=topics, partition=2),
    TopicPartition(topic=topics, partition=3),
    TopicPartition(topic=topics, partition=4),
    TopicPartition(topic=topics, partition=5),
    TopicPartition(topic=topics, partition=6),
    TopicPartition(topic=topics, partition=7)
])

producer = KafkaProducer(bootstrap_servers=brokers,
                         value_serializer=lambda x: json.dumps(x).encode('utf8'),
                         partitioner=partitioner)

e = 1
while True:
    data = {'number' : e}
    producer.send(topics, value=data)
    producer.flush()
    time.sleep(delay)
    print('produced message: {}'.format(data))
    e = e + 1