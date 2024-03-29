data "aws_ami" "nomadic" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "template_file" "nomadic_boot" {
  template = file("${abspath(path.root)}/bootstrap/nomadic.sh")
  vars = {
    BRANCH           = var.nomadic_branch
    CONSUL_VERSION   = var.consul_version
    NOMAD_VERSION    = var.nomad_version
    VAULT_VERSION    = var.vault_version
    PRIVATE_IP_ONE   = var.nomadic_cluster_ip_one
    PRIVATE_IP_TWO   = var.nomadic_cluster_ip_two
    PRIVATE_IP_THREE = var.nomadic_cluster_ip_three
    VAULT_KMS_ID     = aws_kms_key.nomadic.key_id
  }
}

resource "aws_kms_key" "nomadic" {
  description             = "nomadic"
  deletion_window_in_days = 7
}

resource "aws_instance" "nomadic_one" {
  ami                         = var.nomadic_ami_id == "" ? data.aws_ami.nomadic.id : var.nomadic_ami_id
  instance_type               = var.nomadic_instance_size
  key_name                    = var.key_name
  subnet_id                   = local.subnet_id_one
  vpc_security_group_ids      = [local.secgroup_id]
  iam_instance_profile        = aws_iam_instance_profile.nomadic[0].name
  availability_zone           = var.nomadic_availability_zone_one
  private_ip                  = var.nomadic_cluster_ip_one
  user_data                   = data.template_file.nomadic_boot.rendered
  associate_public_ip_address = var.allow_public_ip
  tags                        = local.tags

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    tags        = local.tags
  }
}

resource "aws_instance" "nomadic_two" {
  ami                         = var.nomadic_ami_id == "" ? data.aws_ami.nomadic.id : var.nomadic_ami_id
  instance_type               = var.nomadic_instance_size
  key_name                    = var.key_name
  subnet_id                   = local.subnet_id_two
  vpc_security_group_ids      = [local.secgroup_id]
  iam_instance_profile        = aws_iam_instance_profile.nomadic[0].name
  availability_zone           = var.nomadic_availability_zone_two
  private_ip                  = var.nomadic_cluster_ip_two
  user_data                   = data.template_file.nomadic_boot.rendered
  associate_public_ip_address = var.allow_public_ip
  tags                        = local.tags

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    tags        = local.tags
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
  private_ip                  = var.nomadic_cluster_ip_three
  user_data                   = data.template_file.nomadic_boot.rendered
  associate_public_ip_address = var.allow_public_ip
  tags                        = local.tags

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    tags        = local.tags
  }
}

resource "aws_ssm_parameter" "nomadic_instance_ids" {
  name      = "nomadic_instance_ids"
  type      = "String"
  overwrite = true
  value     = "${aws_instance.nomadic_one.id},${aws_instance.nomadic_two.id},${aws_instance.nomadic_three.id}"
}

resource "aws_ssm_parameter" "nomadic_instance_ips" {
  name      = "nomadic_instance_ips"
  type      = "String"
  overwrite = true
  value     = "${aws_instance.nomadic_one.public_ip},${aws_instance.nomadic_two.public_ip},${aws_instance.nomadic_three.public_ip}"
}
