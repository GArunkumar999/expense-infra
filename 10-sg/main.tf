# creating alb-ingress-sg security group
module "alb-ingress-sg" {
  source       = "github.com/GArunkumar999/terraform.git/sg-module?ref=main"
  project_name = "expense"
  environment  = "dev"
  description  = "security group for alb ingress"
  app          = "back-alb"
  vpc_id       = data.aws_ssm_parameter.vpc_id.value



}

# creating bastion security group
# changed name to bastion_sg due to already exists
module "bastion_sg" {
  source       = "github.com/GArunkumar999/terraform.git/sg-module?ref=main"
  project_name = "expense"
  environment  = "dev"
  description  = "security group for bastion"
  app          = "bastion"
  vpc_id       = data.aws_ssm_parameter.vpc_id.value

}



module "eks-control-plane-sg" {
  source       = "github.com/GArunkumar999/terraform.git/sg-module?ref=main"
  project_name = "expense"
  environment  = "dev"
  description  = "security group for eks control plane"
  app          = "eks-control-plane"
  vpc_id       = data.aws_ssm_parameter.vpc_id.value

}

module "node-sg" {
  source       = "github.com/GArunkumar999/terraform.git/sg-module?ref=main"
  project_name = "expense"
  environment  = "dev"
  description  = "security group for eks control plane"
  app          = "node"
  vpc_id       = data.aws_ssm_parameter.vpc_id.value

}

module "mysql-sg" {
  source       = "github.com/GArunkumar999/terraform.git/sg-module?ref=main"
  project_name = "expense"
  environment  = "dev"
  description  = "security group for mysql"
  app          = "mysql"
  vpc_id       = data.aws_ssm_parameter.vpc_id.value

}

resource "aws_security_group_rule" "alb-ingress-bastion" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.alb-ingress-sg.sg_id
}

resource "aws_security_group_rule" "alb-ingress-bastion-https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.alb-ingress-sg.sg_id
}

resource "aws_security_group_rule" "alb-ingress-public-https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.alb-ingress-sg.sg_id
}

resource "aws_security_group_rule" "eks-control-plane-node" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.node-sg.sg_id
  security_group_id        = module.eks-control-plane-sg.sg_id
}

resource "aws_security_group_rule" "node-eks-control-plane" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.eks-control-plane-sg.sg_id
  security_group_id        = module.node-sg.sg_id
}

resource "aws_security_group_rule" "node-alb-ingress" {
  type                     = "ingress"
  from_port                = 30000
  to_port                  = 32767
  protocol                 = "tcp"
  source_security_group_id = module.alb-ingress-sg.sg_id
  security_group_id        = module.node-sg.sg_id
}

resource "aws_security_group_rule" "mysql-node" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.node-sg.sg_id
  security_group_id        = module.mysql-sg.sg_id
}

resource "aws_security_group_rule" "mysql-bastion" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.mysql-sg.sg_id
}

#eks actually do dns resolution on udp
resource "aws_security_group_rule" "node-vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = module.node-sg.sg_id
}

resource "aws_security_group_rule" "node-bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.node-sg.sg_id
}

resource "aws_security_group_rule" "bastion-public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.sg_id
}

resource "aws_security_group_rule" "eks-control-plane-bastion" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.eks-control-plane-sg.sg_id
}

resource "aws_security_group_rule" "eks-node-alb-ingress" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.alb-ingress-sg.sg_id
  security_group_id        = module.node-sg.sg_id
}

