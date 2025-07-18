resource "aws_acm_certificate" "alb-ingress" {
  domain_name       = "*.${var.domain_name}"
  validation_method = "DNS"

  tags = {
    Name = "${var.project}-${var.environment}-web"
  }

}

# creating r53 record to verify domain is ours or not
resource "aws_route53_record" "alb-ingress-acm" {
  for_each = {
    for dvo in aws_acm_certificate.alb-ingress.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}

# web-acm certificate validation
resource "aws_acm_certificate_validation" "alb-ingress-acm" {
  certificate_arn         = aws_acm_certificate.alb-ingress.arn
  validation_record_fqdns = [for record in aws_route53_record.alb-ingress-acm : record.fqdn]
}


