FROM python:2.7-alpine

ADD consumer.py /

RUN pip install kafka-python

CMD [ "python", "./consumer.py" ]
