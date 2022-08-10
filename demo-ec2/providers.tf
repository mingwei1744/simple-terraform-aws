# Retrieve latest aws plugins
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

/*
Configure the AWS Provider
# Windows: %USERPROFILE%\.aws\
# Linux and MacOS: ~/.aws
*/
provider "aws" {
  region  = "ap-southeast-1"
  profile = var.aws_profile
}
