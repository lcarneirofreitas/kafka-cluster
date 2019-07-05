#################
# Ec2 Docker Host
#################
resource "aws_instance" "dockerhost" {
  ami = "ami-0c6d2529971de8860"
  instance_type = "t2.medium"
  key_name = "mykey"
  associate_public_ip_address = true
  subnet_id = "subnet-0511e9b7a3614f0c9"
  security_groups = [ "${aws_security_group.allow_ssh.id}" ]

  user_data = <<EOF
#!/bin/bash
curl -fsSL https://get.docker.com | sudo bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
#sudo wget http://repo-collystore.s3-website-us-east-1.amazonaws.com/docker-compose.yml
#sudo docker-compose up -d
EOF

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "DockerHost"
  }
}