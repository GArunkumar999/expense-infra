module "eks-vpc" {
  source        = "github.com/GArunkumar999/terraform.git/vpc-main-module?ref=main"
  cidr_block    = "10.0.0.0/16"
  cidr_public   = ["10.0.0.0/24", "10.0.1.0/24"]
  cidr_private  = ["10.0.2.0/24", "10.0.3.0/24"]
  cidr_database = ["10.0.4.0/24", "10.0.5.0/24"]

}
