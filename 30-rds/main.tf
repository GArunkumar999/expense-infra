module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.project}-${var.environment}"

  engine              = "mysql"
  engine_version      = "8.0.40"
  instance_class      = "db.t4g.micro"
  allocated_storage   = 20
  skip_final_snapshot = true




  db_name                     = "transactions"
  username                    = "root"
  port                        = "3306"
  password                    = "ExpenseApp1"
  manage_master_user_password = false

  vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automaticall

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  create_db_subnet_group = false
  db_subnet_group_name   = data.aws_ssm_parameter.subnet_group_name.value

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}