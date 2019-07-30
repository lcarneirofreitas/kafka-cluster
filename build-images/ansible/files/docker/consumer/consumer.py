from json import loads

from kafka import KafkaConsumer
from kafka.structs import OffsetAndMetadata, TopicPartition

consumer = KafkaConsumer(bootstrap_servers=['kafka1:9092','kafka2:9092','kafka3:9092'],
                         value_deserializer=lambda x: loads(x.decode('utf-8')),
                         auto_offset_reset="earliest",
                         group_id='mygroup')

consumer.subscribe(['numtest'])

for message in consumer:

    tp = TopicPartition(message.topic, message.partition)
    offsets = {tp: OffsetAndMetadata(message.offset, None)}
    consumer.commit(offsets=offsets)
    print('message consumed: {}'.format(message))
