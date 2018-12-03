# Configure the S3 backend
terraform {
  required_version = "> 0.11.0"
  backend "s3" {
    bucket = "kickstart-infra.simplificator.com"
    key    = "kickstart/kickstart-infra.tfstate"
    region = "eu-central-1"
  }
}


# Define variables. Credentials and identifiers are loaded from terraform.tfvars
variable "region" {
  default = "eu-central-1"
}

# Configure the AWS Provider
provider "aws" {
  region     = "${var.region}"
}
