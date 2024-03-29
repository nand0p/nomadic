data "aws_caller_identity" "current" {}

resource "aws_security_group" "nomadic_cluster" {
  count       = var.nomadic_security_group_id == "" ? 1 : 0
  name        = "nomadic_cluster"
  description = "nomadic cluster instances"
  vpc_id      = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_ssm_parameter" "nomadic_security_group_id" {
  name      = "nomadic_security_group_id"
  type      = "SecureString"
  overwrite = true
  value     = aws_security_group.nomadic_cluster[0].id
}

resource "aws_security_group_rule" "allow_intra_cluster" {
  count             = var.nomadic_security_group_id == "" ? 1 : 0
  type              = "ingress"
  protocol          = "all"
  from_port         = 1
  to_port           = 65535
  security_group_id = aws_security_group.nomadic_cluster[0].id
  cidr_blocks = [
    "${var.nomadic_cluster_ip_one}/32",
    "${var.nomadic_cluster_ip_two}/32",
    "${var.nomadic_cluster_ip_three}/32"
  ]
}

resource "aws_security_group_rule" "allow_ssh" {
  count             = var.nomadic_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.nomadic_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_nomad" {
  count             = var.nomadic_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 4646
  to_port           = 4648
  protocol          = "tcp"
  security_group_id = aws_security_group.nomadic_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_consul_serf_tcp" {
  count             = var.nomadic_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 8300
  to_port           = 8302
  protocol          = "tcp"
  security_group_id = aws_security_group.nomadic_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_consul_serf_udp" {
  count             = var.nomadic_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 8301
  to_port           = 8302
  protocol          = "udp"
  security_group_id = aws_security_group.nomadic_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_consul_gossip_udp" {
  count             = var.nomadic_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 7301
  to_port           = 7301
  protocol          = "udp"
  security_group_id = aws_security_group.nomadic_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_consul_gossip_tcp" {
  count             = var.nomadic_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 7300
  to_port           = 7301
  protocol          = "tcp"
  security_group_id = aws_security_group.nomadic_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_consul_api" {
  count             = var.nomadic_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 8500
  to_port           = 8502
  protocol          = "tcp"
  security_group_id = aws_security_group.nomadic_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_consul_dns_tcp" {
  count             = var.nomadic_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 8600
  to_port           = 8600
  protocol          = "tcp"
  security_group_id = aws_security_group.nomadic_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_consul_dns_udp" {
  count             = var.nomadic_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 8600
  to_port           = 8600
  protocol          = "udp"
  security_group_id = aws_security_group.nomadic_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_vault" {
  count             = var.nomadic_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 8200
  to_port           = 8201
  protocol          = "tcp"
  security_group_id = aws_security_group.nomadic_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_http" {
  count             = var.nomadic_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.nomadic_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_vault_api" {
  count             = var.nomadic_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.nomadic_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_docker_ephemeral" {
  count             = var.nomadic_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 20000
  to_port           = 32000
  protocol          = "tcp"
  security_group_id = aws_security_group.nomadic_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_iam_instance_profile" "nomadic" {
  count = var.nomadic_instance_profile_name == "" ? 1 : 0
  name  = var.stack_name
  role  = aws_iam_role.nomadic[0].name
}

resource "aws_iam_role" "nomadic" {
  count              = var.nomadic_instance_profile_name == "" ? 1 : 0
  name               = var.stack_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.nomadic.json
  tags               = local.tags
}

data "aws_iam_policy_document" "nomadic" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "nomadic" {
  count  = var.nomadic_instance_profile_name == "" ? 1 : 0
  name   = var.stack_name
  role   = aws_iam_role.nomadic[0].name
  policy = file("${abspath(path.root)}/nomadic_iam_policy.json")
}
