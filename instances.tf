data "aws_ami" "nomadic" {
 most_recent = true
 owners = [ "amazon" ]

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

data "template_file" "nomadic_boot" {
  template = file("${abspath(path.root)}/boot_scripts/nomadic.sh")
  vars = {
    BRANCH = "terraform-001"
    CONSUL_VERSION = "1.11.2"
    NOMAD_VERSION = "1.2.4"
    VAULT_VERSION = "1.9.2"
    PRIVATE_IP_ONE = var.nomadic_cluster_ip_one
    PRIVATE_IP_TWO = var.nomadic_cluster_ip_two
    PRIVATE_IP_THREE = var.nomadic_cluster_ip_three
  }
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
  tags                        = var.tags

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    tags        = var.tags
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
  tags                        = var.tags

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
  private_ip                  = var.nomadic_cluster_ip_three
  user_data                   = data.template_file.nomadic_boot.rendered
  associate_public_ip_address = var.allow_public_ip
  tags                        = var.tags

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    tags        = var.tags
  }
}
