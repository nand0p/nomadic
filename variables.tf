variable "stack_name" {
  type = string
}

variable "tags" {
  type = map
}

variable "aws_profile" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "timestamp" {
  type = string
}

variable "trusted_cidrs" {
  type = list
}

variable "key_name" {
  type = string
}

variable "nomadic_instance_size" {
  type = string
}

variable "root_volume_type" {
  type = string
}

variable "root_volume_size" {
  type = string
}

variable "nomadic_vpc_id" {
  type = string
}

variable "nomadic_subnet_id_one" {
  type = string
}

variable "nomadic_subnet_id_two" {
  type = string
}

variable "nomadic_subnet_id_three" {
  type = string
}

variable "nomadic_security_group_id" {
  type = string
}

variable "nomadic_instance_profile_name" {
  type = string
}

variable "nomadic_vpc_cidr" {
  type = string
}

variable "nomadic_subnet_cidr_one" {
  type = string
}

variable "nomadic_subnet_cidr_two" {
  type = string
}

variable "nomadic_subnet_cidr_three" {
  type = string
}

variable "nomadic_availability_zone_one" {
  type = string
}

variable "nomadic_availability_zone_two" {
  type = string
}

variable "nomadic_availability_zone_three" {
  type = string
}

variable "nomadic_ami_id" {
  type = string
}

locals {
  vpc_id                = var.nomadic_vpc_id != "" ? var.nomadic_vpc_id : aws_vpc.nomadic[0].id
  subnet_id_one         = var.nomadic_subnet_id_one != "" ? var.nomadic_subnet_id_one : aws_subnet.nomadic_one[0].id
  subnet_id_two         = var.nomadic_subnet_id_two != "" ? var.nomadic_subnet_id_two : aws_subnet.nomadic_two[0].id
  subnet_id_three       = var.nomadic_subnet_id_three != "" ? var.nomadic_subnet_id_three : aws_subnet.nomadic_three[0].id
  secgroup_id           = var.nomadic_security_group_id != "" ? var.nomadic_security_group_id : aws_security_group.nomadic_cluster[0].id
  instance_profile_name = var.nomadic_instance_profile_name != "" ? var.nomadic_instance_profile_name : aws_iam_instance_profile.nomadic[0].name

  tags = merge({
    Name        = var.stack_name,
    Environment = var.environment,
    Timestamp   = var.timestamp,
  }, var.tags)
}
