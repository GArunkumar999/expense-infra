data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project}/${var.environment}/mysql_sg_id"

}

# output "sg_id" {
#     value = data.aws_ssm_parameter.mysql_sg_id.value

# }

data "aws_ssm_parameter" "subnet_group_name" {
  name = "/${var.project}/${var.environment}/db_group_name"
}

# output "name" {
#     value = module.db.db_instance_address

# }