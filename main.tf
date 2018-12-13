# Configure the S3 backend
terraform {
  required_version = "> 0.11.0"
  backend "s3" {
    bucket = "kickstart-infra.simplificator.com"
    key    = "kickstart/kickstart-infra.tfstate"
    region = "eu-central-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "${var.aws_region}"
}

# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "${var.project_env}-${var.project_name}"
    Environment = "${var.project_env}"
    Project = "${var.project_name}"
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "${var.project_env}-${var.project_name}"
    Environment = "${var.project_env}"
    Project = "${var.project_name}"
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.project_env}-${var.project_name}"
    Environment = "${var.project_env}"
    Project = "${var.project_name}"
  }
}

# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "elb" {
  name        = "terraform_example_elb"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.default.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.project_env}-${var.project_name}"
    Environment = "${var.project_env}"
    Project = "${var.project_name}"
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "terraform_example"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.default.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # cidr_blocks = ["10.0.0.0/16"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.project_env}-${var.project_name}"
    Environment = "${var.project_env}"
    Project = "${var.project_name}"
  }
}

resource "aws_elb" "app" {
  name = "terraform-example-elb"

  subnets         = ["${aws_subnet.default.id}"]
  security_groups = ["${aws_security_group.elb.id}"]
  instances       = ["${aws_instance.app.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  tags {
    Name = "${var.project_env}-${var.project_name}"
    Environment = "${var.project_env}"
    Project = "${var.project_name}"
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.project_env}-${var.project_name}"
  public_key = "${file("${var.key_path}/${var.key_name}.pub")}"
}

resource "aws_instance" "app" {
  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # The name of our SSH keypair we created above.
  key_name = "${aws_key_pair.auth.id}"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = "${aws_subnet.default.id}"

  tags {
    Name = "${var.project_env}-${var.project_name}-app"
    Environment = "${var.project_env}"
    Role = "app"
    Project = "${var.project_name}"
  }

  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "ec2-user"
    private_key = "${file("${var.key_path}/${var.key_name}")}"
    # The connection will use the local SSH agent for authentication.
  }

  # We run a remote provisioner on the instance after creating it.
  # In this case, we install docker and start the respective service.
  # Alternatively this could be done by providing a pre-baked AMI.
  # However, it is good practice to check with `remote-exec` that connection is possible 
  # and hence the instance is ready for any further usage (e.g. in deployment pipelines).
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo service docker start",
      "sudo usermod -aG docker $USER",
      "sudo docker version"
    ]
  }
}
