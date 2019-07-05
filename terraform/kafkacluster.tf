###################
# Ec2 Kafka Cluster
###################
resource "aws_instance" "kafkacluster" {
  count = "${length(var.subnets_ips)}"
  ami = "ami-0c6d2529971de8860"
  instance_type = "t2.medium"
  key_name = "mykey"
  private_ip = "${element(var.subnets_ips,count.index)}"
  subnet_id = "${element(aws_subnet.public.*.id,count.index)}"
  security_groups = [ "${aws_security_group.allow_kafka.id}" ]

  user_data = <<EOF
#!/bin/bash
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
