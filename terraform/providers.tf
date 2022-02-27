terraform {
  required_providers {
    aws = {
      version = "~> 3.27"
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  shared_credentials_file = "~/.aws/credentials"
}