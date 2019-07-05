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
