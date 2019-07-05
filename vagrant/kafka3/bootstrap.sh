#!/bin/bash

# install packages kafka
apt-get install -y openjdk-8-jdk && \
	dpkg -i /vagrant/kafka_2.12-2.1.1_amd64.deb

# copy confs default
cp -pvr /vagrant/etc/kafka/* /etc/kafka/ && \
cp -pvr /vagrant/etc/zookeeper/* /etc/zookeeper/

# Add hosts entries (mocking DNS) - put relevant IPs here
echo "192.168.33.50 kafka1
192.168.33.50 zookeeper1
192.168.33.51 kafka2
192.168.33.51 zookeeper2
192.168.33.52 kafka3
192.168.33.52 zookeeper3" | sudo tee --append /etc/hosts

# set myid zookeeper cluster
echo "3" > /data/zookeeper/myid

# start zookeeper
service zookeeper stop && sleep 10 && \
service zookeeper start && sleep 10 && \

# start kafka
service kafka stop && sleep 10 && \
service kafka start && sleep 10 && \

# check zookeeper status
echo "ruok" | nc localhost 2181 ; echo
