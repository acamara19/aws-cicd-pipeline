terraform {
  required_version = "~> 1.1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    skip_credentials_validation = true
    skip_region_validation      = true
  }
}

provider "aws" {
  region = var.region
}