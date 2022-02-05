data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "nomadic_subnets" {
  name = "nomadic_subnets"
}

data "aws_ssm_parameter" "nomadic_instance_ips" {
  name = "nomadic_instance_ips"
}

data "aws_ssm_parameter" "nomadic_instance_ids" {
  name = "nomadic_instance_ids"
}

data "aws_ssm_parameter" "nomadic_security_group_id" {
  name = "nomadic_security_group_id"
}

data "aws_ssm_parameter" "nomadic_ssh_key" {
  name = "nomadic_ssh_key"
}

data "aws_ssm_parameter" "warship_pipelines_s3" {
  name = "warship_pipelines_s3"
}

data "aws_ssm_parameter" "warship_pipelines_iam_role_arn" {
  name = "warship_pipelines_iam_role_arn"
}
