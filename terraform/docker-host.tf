#################
# Ec2 Docker Host
#################
resource "aws_instance" "dockerhost" {
  ami = "ami-0bc7ff066378d2170"
  instance_type = "t2.medium"
  key_name = "mykey"
  associate_public_ip_address = true
  subnet_id = "subnet-0a3ff5339ed0481eb"
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
sudo cd /home/ubuntu/install-scripts
sudo docker-compose up -d
EOF

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "DockerHost"
  }
}
output "ec2_global_ips" {
  value = ["${aws_instance.dockerhost.*.public_ip}"]
}
