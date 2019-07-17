#################
# Ec2 Docker Host
#################
resource "aws_instance" "dockerhost" {
  ami = "${var.ami_kafka}"
  instance_type = "${var.instance_type_kafka}"
  key_name = "mykey"
  associate_public_ip_address = true
  subnet_id = "${var.subnet_kafka}"
  security_groups = [ "${aws_security_group.allow_ssh.id}" ]

  user_data = <<EOF
#!/bin/bash

# Add hosts entries (mocking DNS) - put relevant IPs here
echo "# Golden Image Kafka Teravoz
172.16.10.100 kafka1
172.16.10.100 zookeeper1
172.16.11.100 kafka2
172.16.11.100 zookeeper2
172.16.12.100 kafka3
172.16.12.100 zookeeper3" | sudo tee --append /etc/hosts

curl -fsSL https://get.docker.com | sudo bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo usermod -a -G docker dd-agent
sudo service datadog-agent restart
sudo docker-compose -f /home/ubuntu/ansible/files/docker/docker-compose.yml up -d

EOF

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "DockerHost"
  }
}