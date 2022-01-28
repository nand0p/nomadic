provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

terraform {
  backend "s3" {
    bucket  = "nomadic-tfstate"
    key     = "nomadic.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "nomadic"
  }
}

data "aws_caller_identity" "current" {}
