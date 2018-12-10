variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.

Example: ~/.ssh/terraform.pub
DESCRIPTION
  default = "~/.ssh/terraform.pub"
}

variable "public_key" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.

Example: ~/.ssh/terraform.pub
DESCRIPTION
  default = <<KEY
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVJxb/i66MZxiT0dz3pqRkk2c8SsyKrveKe0YxBNet1KJeqAGiYr0Q6bJGPFCPf/lA0n6fbJyI+x7ehb/mftpe1kc9pRIFB5DT2JQKBVvFA6hNd6neGUnQBrqJGjPOTWVQjN8gZOLezCI67x0Hud0YoyF4+V/e8FF+bus60SLzTa6CORJVnxcXyIDcR3EI9axunLaLwFJMpZYF2VDR/vS9gfJ+n0ChiKbXzLiJuxj2qgQrJag6Ci7nIyVR8CqIy13CC4wtmQvBLQmMgx7IzNfnH/sp8UEPbu0+7wqpYeIKgUW6AehhytIRXft2EQkjyjnJwnvpdimwdo3YazVg4ceBSCqfFNteQzc/ytWXFSE5PBOhoAkiBKZldsWRt0rAT0M2E9NxtmvWZHAoxw3gkgq+2uzXsKEzNQpdck4AOB5H+7ttgA6DWgI9uSHZYgDA9J2yFzyLTG4ig3wy+p5PSnTEeBJqHZe/d8bpsFgiNOj/u0ZtWXwLT7HSpdlyo4tMvl3etEXD7w3G/Zsn1ttJ7l5X4LhqB4lHzROVJu2xmR0fNrTmXiUWzaw/ddUk/ClcktMOeeuUr36HcAQZimA9tNI54ygpNf/dVYFGv6Lxqgc19Hn+9BOYNW3RYJzG+rAIIx1gy6UIWD5FBSzdLZsAhpeiE1oLIVjYUvIK3Er6ScxpTQ== tom.pluess@simplificator.com
KEY
}


variable "key_name" {
  description = "Desired name of AWS key pair"
  default = "tom.pluess@simplificator.com"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-central-1"
}

# Ubuntu Precise 12.04 LTS (x64)
variable "aws_amis" {
  default = {
    eu-central-1 = "ami-0cfbf4f6db41068ac" # Amazon Linux AMI 2018.03.0 (HVM)
    eu-west-1    = "ami-674cbc1e"
    us-east-1    = "ami-1d4e7a66"
    us-west-1    = "ami-969ab1f6"
    us-west-2    = "ami-8803e0f0"
  }
}
