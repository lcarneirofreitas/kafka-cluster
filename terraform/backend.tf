####################
# Storage tfstate s3
####################
terraform {
  backend "s3" {
    bucket = "terraform-state-kafkacluster1"
    key = "terraform/terraform.tfstate1"
  }
}
