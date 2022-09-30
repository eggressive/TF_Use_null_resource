terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile    = "default"
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

data "aws_ssm_parameter" "ami_id" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ssm_parameter.ami_id.value
  instance_type = "t3.micro"

  tags = {
    Name = var.instance_name
  }
}

resource "null_resource" "ec2_status" {
  provisioner "local-exec" {
    command = "./scripts/health.sh"
  }
}