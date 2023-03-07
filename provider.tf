#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
#
# https://github.com/hashicorp/terraform-provider-aws
#

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.57.0"
    }
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}