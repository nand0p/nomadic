resource "aws_route53_record" "nomadic_vault" {
  name    = "vault"
  zone_id = var.dns_hosted_zone_id
  ttl     = "300"
  type    = "A"
  records = [aws_instance.nomadic_one.public_ip]
}

resource "aws_route53_record" "nomadic_one" {
  name    = "one"
  zone_id = var.dns_hosted_zone_id
  ttl     = "300"
  type    = "A"
  records = [aws_instance.nomadic_one.public_ip]
}

resource "aws_route53_record" "nomadic_two" {
  name    = "two"
  zone_id = var.dns_hosted_zone_id
  ttl     = "300"
  type    = "A"
  records = [aws_instance.nomadic_two.public_ip]
}

resource "aws_route53_record" "nomadic_three" {
  name    = "three"
  zone_id = var.dns_hosted_zone_id
  ttl     = "300"
  type    = "A"
  records = [aws_instance.nomadic_three.public_ip]
}
