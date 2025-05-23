locals {
  private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  vpc_id             = data.aws_ssm_parameter.vpc_id.value
  eks_sg_id          = data.aws_ssm_parameter.eks-control-plane-sg-id.value
  node_sg_id         = data.aws_ssm_parameter.node-sg-id.value

}