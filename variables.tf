
variable "project_name" {
  description = "A descriptive name for your project. will be used to name and tag resources"
  default     = "kickstart"
}

variable "project_env" {
  description = "A descriptive name for your environment. will be used to name and tag resources"
  default     = "DEMO"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-central-1"
}

# Amazon Linux AMI 2018.03.0 (HVM)
variable "aws_amis" {
  default = {
    eu-central-1 = "ami-0cfbf4f6db41068ac"
  }
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default = "kickstart"
}

variable "key_path" {
  description = <<DESCRIPTION
Path to the SSH private key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.

Example: ~/.ssh/
DESCRIPTION
  default = "~/.ssh"
}
