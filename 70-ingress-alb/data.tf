data "aws_ssm_parameter" "alb_ingress_sg_id" {
  name = "/${var.project}/${var.environment}/alb_ingress_sg_id"
}
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}/${var.environment}/public_subnet_ids"
}

data "aws_ssm_parameter" "alb_ingress_certificate_arn" {
  name = "/${var.project}/${var.environment}/alb_ingress_certificate_arn"
}



