module "rds" {
  source                     = "terraform-aws-modules/rds/aws"
  identifier                 = "team2db"
  engine                     = "mysql"
  major_engine_version       = "8.0"
  auto_minor_version_upgrade = true
  instance_class             = "db.t3.micro"
  allocated_storage          = 5
  family                     = "mysql8.0"
  port                       = "3306"

  manage_master_user_password = true
  //TODO probably create user via smtg else
  username                    = "team2user"
  db_name                     = "DBteam2"

  #   create_cloudwatch_log_group = true
  #   cloudwatch_log_group_class  = "STANDARD"
  #   enabled_cloudwatch_logs_exports = ["general"]
  #   create_monitoring_role      = true

  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets
  vpc_security_group_ids = [module.rds-sg.security_group_id]
  deletion_protection    = false //TODO should bre true before preview
}