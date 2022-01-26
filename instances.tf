data "aws_ami" "nomadic" {
 most_recent = true
 owners = [ "amazon" ]

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

resource "aws_instance" "nomadic_one" {
  ami                         = var.nomadic_ami_id == "" ? data.aws_ami.nomadic.id : var.nomadic_ami_id
  instance_type               = var.nomadic_instance_size
  key_name                    = var.key_name
  subnet_id                   = local.subnet_id_one
  associate_public_ip_address = false
  vpc_security_group_ids      = [local.secgroup_id]
  iam_instance_profile        = aws_iam_instance_profile.nomadic[0].name
  availability_zone           = var.nomadic_availability_zone_one
  user_data                   = file("${abspath(path.root)}/boot_scripts/nomadic_one.sh")
  tags                        = var.tags

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    tags        = var.tags
  }
}

resource "aws_instance" "nomadic_two" {
  ami                    = var.nomadic_ami_id == "" ? data.aws_ami.nomadic.id : var.nomadic_ami_id
  instance_type          = var.nomadic_instance_size
  key_name               = var.key_name
  subnet_id              = local.subnet_id_two
  vpc_security_group_ids = [local.secgroup_id]
  iam_instance_profile   = aws_iam_instance_profile.nomadic[0].name
  availability_zone      = var.nomadic_availability_zone_two
  user_data              = file("${abspath(path.root)}/boot_scripts/nomadic_two.sh")
  tags                   = var.tags

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    tags        = var.tags
  }
}

resource "aws_instance" "nomadic_three" {
  ami                         = var.nomadic_ami_id == "" ? data.aws_ami.nomadic.id : var.nomadic_ami_id
  instance_type               = var.nomadic_instance_size
  key_name                    = var.key_name
  subnet_id                   = local.subnet_id_three
  vpc_security_group_ids      = [local.secgroup_id]
  iam_instance_profile        = aws_iam_instance_profile.nomadic[0].name
  availability_zone           = var.nomadic_availability_zone_three
  user_data                   = file("${abspath(path.root)}/boot_scripts/nomadic_three.sh")
  tags                        = var.tags

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    tags        = var.tags
  }
}

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
