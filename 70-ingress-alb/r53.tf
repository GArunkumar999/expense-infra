resource "aws_route53_record" "web-alb" {
  zone_id = "Z0720927H41Q39EST49L"
  name    = "${var.project}-${var.environment}.devopslearning.fun"
  type    = "A"

  alias {
    name                   = module.ingress-alb.dns_name
    zone_id                = module.ingress-alb.zone_id
    evaluate_target_health = false
  }
}