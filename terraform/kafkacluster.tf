###################
# Ec2 Kafka Cluster
###################
resource "aws_instance" "kafkacluster" {
  count = "${length(var.subnets_ips)}"
  ami = "ami-07032bc677341bf33"
  instance_type = "t2.medium"
  key_name = "mykey"
  associate_public_ip_address = true
  private_ip = "${element(var.subnets_ips,count.index)}"
  subnet_id = "${element(aws_subnet.public.*.id,count.index)}"
  security_groups = [ "${aws_security_group.allow_kafka.id}" ]

  user_data = <<EOF
#!/bin/bash

# Add hosts entries (mocking DNS) - put relevant IPs here
echo "# Golden Image Kafka Teravoz
172.16.10.100 kafka1
172.16.10.100 zookeeper1
172.16.11.100 kafka2
172.16.11.100 zookeeper2
172.16.12.100 kafka3
172.16.12.100 zookeeper3
127.0.0.1 $HOSTNAME" | sudo tee --append /etc/hosts

sudo sed -i "s/MYID/${count.index+1}/" /data/zookeeper/myid /etc/kafka/server.properties
sudo service zookeeper stop
sleep 10
sudo service zookeeper start
sleep 10
sudo service kafka stop
sleep 10
sudo service kafka start


EOF

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "kafka${count.index+1}"
  }
}
