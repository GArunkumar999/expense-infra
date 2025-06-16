resource "aws_db_subnet_group" "mysql" {
  name       = "mysql"
  subnet_ids = module.eks-vpc.database_subnet_ids

  tags = {
    Name = "mysql db subnet group"
  }
}

