output "nomadic_one_instance_id" {
  value = aws_instance.nomadic_one.id
}

output "nomadic_two_instance_id" {
  value = aws_instance.nomadic_two.id
}

output "nomadic_three_instance_id" {
  value = aws_instance.nomadic_three.id
}

output "nomadic_one_private_ip" {
  value = aws_instance.nomadic_one.private_ip
}

output "nomadic_two_private_ip" {
  value = aws_instance.nomadic_two.private_ip
}

output "nomadic_three_private_ip" {
  value = aws_instance.nomadic_three.private_ip
}

output "nomadic_one_public_ip" {
  value = aws_instance.nomadic_one.public_ip
}

output "nomadic_two_public_ip" {
  value = aws_instance.nomadic_two.public_ip
}

output "nomadic_three_public_ip" {
  value = aws_instance.nomadic_three.public_ip
}

output "tags" {
  value = var.tags
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "aws_caller_user" {
  value = data.aws_caller_identity.current.user_id
}
