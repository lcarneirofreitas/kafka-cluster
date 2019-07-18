FROM python:2.7-alpine

ADD producer.py /

RUN pip install kafka-python

CMD [ "python", "./producer.py" ]

