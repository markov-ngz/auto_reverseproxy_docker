data "aws_route53_zone" "primary" {
  name         = var.dns_name
  private_zone = false
}
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.dns_name
  type    = "A"
  ttl     = 300
  records = [aws_instance.reverseproxy.public_ip]
}