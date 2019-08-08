#########
# Vpc Aws
#########
resource "aws_vpc" "kafka_vpc" {
  cidr_block = "${var.vpc_cidr}"
  tags = {
    Name = "Kafka_Vpc"
  }
}

##################
# Internet Gateway
##################
resource "aws_internet_gateway" "kafka_igw" {
  vpc_id = "${aws_vpc.kafka_vpc.id}"
  tags = {
    Name = "Kafka_Igw"
  }
}

#########
# Subnets
#########
resource "aws_subnet" "public" {
  count = "${length(var.subnets_cidr)}"
  vpc_id = "${aws_vpc.kafka_vpc.id}"
  cidr_block = "${element(var.subnets_cidr,count.index)}"
  availability_zone = "${element(var.azs,count.index)}"
  tags = {
    Name = "Kafka_Subnet_${count.index+1}"
  }
}

#############
# Route table
############# 
resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.kafka_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.kafka_igw.id}"
  }
  tags = {
    Name = "Kafka_Route_Table"
  }
}

#########################
# Route table association
#########################
resource "aws_route_table_association" "a" {
  count = "${length(var.subnets_cidr)}"
  subnet_id = "${element(aws_subnet.public.*.id,count.index)}"
  route_table_id = "${aws_route_table.public_rt.id}"
}
