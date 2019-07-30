import json

from kafka import KafkaProducer, TopicPartition
from kafka.partitioner import RoundRobinPartitioner


# given that numtest `numtest` has at least 8 partitions
partitioner = RoundRobinPartitioner(partitions=[
    TopicPartition(topic='numtest', partition=0),
    TopicPartition(topic='numtest', partition=1),
    TopicPartition(topic='numtest', partition=2),
    TopicPartition(topic='numtest', partition=3),
    TopicPartition(topic='numtest', partition=4),
    TopicPartition(topic='numtest', partition=5),
    TopicPartition(topic='numtest', partition=6),
    TopicPartition(topic='numtest', partition=7)
])

producer = KafkaProducer(bootstrap_servers=['kafka1:9092','kafka2:9092','kafka3:9092'],
                         value_serializer=lambda x: json.dumps(x).encode('utf8'),
                         partitioner=partitioner)

e = 1
while True:
    data = {'number' : e}
    producer.send('numtest', value=data)
    producer.flush()
    #sleep(0.1)
    print('produced message: {}'.format(data))
    e = e + 1
