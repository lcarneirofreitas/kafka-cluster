import os
from json import loads
from kafka import KafkaConsumer
from kafka.structs import OffsetAndMetadata, TopicPartition

brokers = os.environ['BROKERS']
groupid = os.environ['GROUPID']
topic = os.environ['TOPIC']

consumer = KafkaConsumer(bootstrap_servers=brokers,
                         value_deserializer=lambda x: loads(x.decode('utf-8')),
                         auto_offset_reset="earliest",
                         max_poll_interval_ms=600000,
                         group_id=groupid)

consumer.subscribe([topic])

for message in consumer:

    tp = TopicPartition(message.topic, message.partition)
    offsets = {tp: OffsetAndMetadata(message.offset, None)}
    consumer.commit(offsets=offsets)
    print('message consumed: {}'.format(message))