# Kafka Cluster lab


## Terraform + packer + ansible + fpm (deb packages)

Creating kafka cluster environment using the tools:

- fpm                https://github.com/jordansissel/fpm
- packer             https://www.packer.io/
- ansible            https://docs.ansible.com/ansible/latest/index.html
- terraform          https://www.terraform.io/


## Configuring the local environment for running commands

- clone project git
```bash
git clone https://github.com/lcarneirofreitas/kafka-cluster.git
```

- install fpm:                          https://fpm.readthedocs.io/en/latest/installing.html

- install packer:                       https://www.packer.io/downloads.html

- install terraform:                    https://www.terraform.io/downloads.html

- configure credentials awscli AWS:     https://docs.aws.amazon.com/pt_br/cli/latest/userguide/cli-chap-configure.html

- configure the "build_golden_ami.sh" script with the network information from your aws account, variable "KAFKA_VG"


## 3 Steps :)

1 - "fpm" Creating .deb package with the kafka + zookeeper project source
```bash
cd build-images/source/kafka/

make
```
Obs: More details read Makefile


2 - "packer" Provisioning the ec2 linux image in aws "AMI", responsible for the kafka cluster node
```bash
cd build-images/

./build_golden_ami.sh -I kafka v01 vg
```
Obs: Get the id of the new ami generated by the packer, we will use this information in the configurations of terraform, Ex:

```bash
==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs: AMIs were created:
us-east-1: ami-08c78539e097f70b7                    <<<<<<<<<<<<< AMI AWS kafka node
```

3 - "terraform" Provisioning of cloud components
```bash
cd terraform/

sed -i "s/NEW_AMI_KAFKA/ami-08c78539e097f70b7/g" variables.tf

terraform plan

terraform apply

sed -i "s/SUBNET_KAFKA/daada/g" variables.tf

mv docker-host.tf-old docker-host.tf

terraform apply -target=aws_instance.dockerhost
```

