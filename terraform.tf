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

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "aws_caller_user" {
  value = data.aws_caller_identity.current.user_id
}
