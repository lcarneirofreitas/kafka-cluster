###########
# Variables
###########
variable "aws_region" {
	default = "us-east-1"
}

variable "PATH_TO_PUBLIC_KEY" { 
	default = "files/mykey" 
}

variable "vpc_cidr" {
	default = "172.16.0.0/16"
}

variable "ami_kafka" {
	default = "ami-0587ac28187b27d7e"
}

variable "instance_type_kafka" {
	default = "t2.medium"
}

variable "subnet_kafka" {
	default = "subnet-0369ba4150c7f8820"
}

variable "subnets_cidr" {
	type = "list"
	default = [ "172.16.10.0/24",
				"172.16.11.0/24",
				"172.16.12.0/24",
		]
}

variable "subnets_ips" {
	type = "list"
	default = [	"172.16.10.100",
				"172.16.11.100",
				"172.16.12.100",
		]
}

variable "azs" {
	type = "list"
	default = [	"us-east-1a",
				"us-east-1b",
				"us-east-1c",
		]
}
