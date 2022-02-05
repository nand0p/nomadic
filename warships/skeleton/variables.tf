variable "tags" {
  type = map(any)
}

variable "aws_profile" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "efs_enable" {
  type = string
}

variable "elb_enable" {
  type = string
}

variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "timestamp" {
  type = string
}

locals {
  tags = merge({
    Name        = var.app_name,
    Environment = var.environment,
    Timestamp   = var.timestamp,
  }, var.tags)
}
