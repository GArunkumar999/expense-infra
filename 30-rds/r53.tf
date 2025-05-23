resource "aws_route53_record" "mysql-dev" {
  zone_id = var.zone_id
  name    = "mysql-${var.environment}.${var.domain}"
  type    = "CNAME"
  ttl     = 1
  records = [module.db.db_instance_address]
}

