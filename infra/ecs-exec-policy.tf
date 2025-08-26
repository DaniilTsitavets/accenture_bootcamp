module "ecs-task-secrets-policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name_prefix = "ecs-task-secrets-"
  path        = "/"
  description = "Allow ECS task execution role to read RDS secrets"

  policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "secretsmanager:GetSecretValue"
          ],
          "Resource": ["${data.aws_secretsmanager_secret_version.rds_creds_version.arn}"]
        }
      ]
    }
  EOF

  tags = var.tags
}