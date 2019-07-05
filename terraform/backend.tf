####################
# Storage tfstate s3
####################
terraform {
  backend "s3" {
    bucket = "terraform-state-kafkacluster"
    key = "terraform/terraform.tfstate"
  }
}
