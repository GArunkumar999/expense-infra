resource "aws_ssm_parameter" "alb_ingress_certificate_arn" {
  name  = "/${var.project}/${var.environment}/alb_ingress_certificate_arn"
  type  = "String"
  value = aws_acm_certificate.alb-ingress.arn
}