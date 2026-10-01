terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "demo"
      ManagedBy   = "Terraform"
      Repository  = "aws-terraform-modules"
      Example     = "rds-mysql"
    }
  }
}
