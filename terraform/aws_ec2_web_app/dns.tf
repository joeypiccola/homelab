# get zone data for aws_route53_record
data "aws_route53_zone" "zone" {
  name = var.zone
}

# create the record
resource "aws_route53_record" "record" {
  type    = "A"
  name    = var.name
  zone_id = data.aws_route53_zone.zone.zone_id
  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = false
  }
}
