terraform {
  required_version = ">= 1.7.0"

  backend "s3" {
    bucket         = "empportal-tfstate-360131674413"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "empportal-tf-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project     = "employee-management-portal"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}