from time import sleep
from json import dumps
from kafka import KafkaProducer

producer = KafkaProducer(bootstrap_servers=['kafka1:9092','kafka2:9092','kafka3:9092'],
                         value_serializer=lambda x: 
                         dumps(x).encode('utf-8'))

#for e in range(1000):
e = 1
while True:
    data = {'number' : e}
    producer.send('numtest', value=data)
    #sleep(0.1)
    print('produced message: {}'.format(data))
    e = e + 1
