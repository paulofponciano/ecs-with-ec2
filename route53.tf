data "aws_route53_zone" "this" {
  name = replace(var.domain_name, "/.*\\b(\\w+\\.\\w+)\\.?$/", "$1")
}

resource "aws_route53_record" "service_record" {
  name    = var.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.this.zone_id

  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = true
  }
}