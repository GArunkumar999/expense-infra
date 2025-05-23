data "aws_ssm_parameter" "vpc_id" {
  name = "/expense/dev/vpc_id"
}

# output "vpc-id" {

#   value = data.aws_ssm_parameter.vpc_id.value
# }

# output "mysql-id" {
#   value = module.mysql-sg.sg_id
# }