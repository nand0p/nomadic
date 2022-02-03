resource "aws_elb" "nomadic_skeleton" {
  count                       = var.elb_enable ? 1 : 0
  name                        = var.app_name
  instances                   = "${split(",", data.aws_ssm_parameter.nomadic_instances.value)}"
  subnets                     = "${split(",", data.aws_ssm_parameter.nomadic_subnets.value)}"
  security_groups             = [data.aws_ssm_parameter.nomadic_security_group_id.value]
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

output "elb_dns_name" {
  value = var.elb_enable ? aws_elb.nomadic_skeleton[0].dns_name : "none"
}
