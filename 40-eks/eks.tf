resource "aws_key_pair" "eks" {
  key_name   = "expense-eks"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCCMblbjOvv4wb3jheKqiDT0QkJ7sHSTaM2x0pDj/IU+P1KY/7lrKsEXEWSWcAubG7v9h9L5aSh/vLSB9FGo6qID09RADRFRybFPrykaVSd+Kuo5bHrmOzkTsaD4hiaRFBYr1Me1ktc4S0Rv0CFuxQM525bG9f9aGcnStOSVgtENGBqVOhho7v7PXX44DqdwR07PhWMysyVC3+uMwBNa4oE+DM2+9hY8HRTmLMaV1pF8z3mfFvbLcMChiemte7pa+4JIz7PE22+fHA6+DVTyyKUb0KNjTUiL2X02pg9ntbK2yyldhMAE+THVZZuFQX8uItYm/3sE9Q5HkB+TBzfR+ii3wye2Dbo973PggCFqJQdnKiwBuhpwli/C3wsxNFylAUpJRGoUQu0GW8pX14I1+G2+fHUYT36FAZ6ETVTnjhcPQFjvOxFeTzDUjuulb1c9FLK5J6Uz5kqddlRJgFnjqFLOMrVrg/VSk4V2B/7BypCitWCKS6bC+tBTnjc5qF1+E= root@ip-172-31-28-45.ec2.internal"

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project}-${var.environment}"
  cluster_version = "1.31" # later we upgrade 1.32
  create_node_security_group = false
  create_cluster_security_group = false
  cluster_security_group_id = local.eks_sg_id
  node_security_group_id = local.node_sg_id

  #bootstrap_self_managed_addons = false
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
    metrics-server = {}
  }

  # Optional
  cluster_endpoint_public_access = false

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = local.vpc_id
  subnet_ids               = local.private_subnet_ids
  control_plane_subnet_ids = local.private_subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    blue = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      #ami_type       = "AL2_x86_64"
      instance_types = ["m5.xlarge"]
      key_name = aws_key_pair.eks.key_name

      min_size     = 2
      max_size     = 10
      desired_size = 2
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonEFSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
        ElasticLoadBalancingFullAccess = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
      }
    }
  }

  tags = {
        Name = "${var.project}-${var.environment}-bastion"

    }
  
}