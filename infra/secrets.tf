data "aws_secretsmanager_secrets" "rds_creds" {
  filter {
    name   = "tag-key"
    values = ["aws:secretsmanager:owningService"]
  }
  filter {
    name   = "tag-value"
    values = ["rds"]
  }
  filter {
    name   = "tag-key"
    values = ["aws:rds:primaryDBInstanceArn"]
  }
  filter {
    name   = "tag-value"
    values = [module.rds.db_instance_arn]
  }
}

data "aws_secretsmanager_secret_version" "rds_creds_version" {
  secret_id = tolist(data.aws_secretsmanager_secrets.rds_creds.arns)[0]
}
