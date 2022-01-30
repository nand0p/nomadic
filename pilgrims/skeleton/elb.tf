data "aws_ssm_parameter" "nomadic_subnets" {
  name = "nomadic_subnets"
}

data "aws_ssm_parameter" "nomadic_instances" {
  name = "nomadic_instances"
}

resource "aws_elb" "skeleton_application" {
  count                       = var.elb_enable ? 1 : 0
  name                        = var.app_name
  instances                   = "${split(",", data.aws_ssm_parameter.nomadic_instances.value)}"
  subnets                     = "${split(",", data.aws_ssm_parameter.nomadic_subnets.value)}"
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  tags                        = local.tags

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  #listener {
  #  instance_port      = 8000
  #  instance_protocol  = "http"
  #  lb_port            = 443
  #  lb_protocol        = "https"
  #  ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  #}

  #access_logs {
  #  bucket        = "foo"
  #  bucket_prefix = "bar"
  #  interval      = 60
  #}
}
