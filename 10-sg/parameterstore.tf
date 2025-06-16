resource "aws_ssm_parameter" "mysql-sg" {
  name  = "/${var.project}/${var.environment}/mysql_sg_id"
  type  = "String"
  value = module.mysql-sg.sg_id
}

resource "aws_ssm_parameter" "alb-ingress-sg" {
  name  = "/${var.project}/${var.environment}/alb_ingress_sg_id"
  type  = "String"
  value = module.alb-ingress-sg.sg_id
}


resource "aws_ssm_parameter" "bastion_sg" {
  name  = "/${var.project}/${var.environment}/bastion_sg_id"
  type  = "String"
  value = module.bastion_sg.sg_id
}

resource "aws_ssm_parameter" "eks-control-plane" {
  name  = "/${var.project}/${var.environment}/eks_control_plane_sg_id"
  type  = "String"
  value = module.eks-control-plane-sg.sg_id
}

resource "aws_ssm_parameter" "node-sg" {
  name  = "/${var.project}/${var.environment}/node_sg_id"
  type  = "String"
  value = module.node-sg.sg_id
}







