module "ecs-cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"
  name   = "team2-cluster"

  default_capacity_provider_strategy = {
    FARGATE = {
      weight = 1
      base   = 1
    }
    FARGATE_SPOT = {
      weight = 3
    }
  }
  tags = var.tags
}

module "ecs-service" {
  source                    = "terraform-aws-modules/ecs/aws//modules/service"
  subnet_ids                = module.vpc.private_subnets
  create_iam_role           = false
  create_tasks_iam_role     = false
  create_task_exec_iam_role = true
  create_task_exec_policy   = true
  name                      = "team2-wordpress"

  security_group_ids = [module.ecs-sg.security_group_id]
  runtime_platform = {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = {
    wordpress = {
      cpu       = 512
      memory    = 1024
      essential = true
      image     = "${module.ecr.repository_url}:latest"
      environment = [
        {
          name  = "WORDPRESS_DB_HOST"
          value = module.rds.db_instance_endpoint
        },
        {
          name  = "WORDPRESS_DB_NAME"
          value = module.rds.db_instance_name
        }
      ]

      secrets = [
        {
          name      = "WORDPRESS_DB_USER"
          valueFrom = data.aws_secretsmanager_secret_version.rds_creds_version.arn
        },
        {
          name      = "WORDPRESS_DB_PASSWORD"
          valueFrom = data.aws_secretsmanager_secret_version.rds_creds_version.arn
        }
      ]
      create_cloudwatch_log_group = false
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/aws/ecs/team2/wordpress"
          awslogs-region        = "eu-west-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  }
  load_balancer = {
    service = {
      target_group_arn = module.alb.target_groups["ex_ecs"].arn
      container_name   = "wordpress"
      container_port   = 80
    }
  }
  tags = var.tags
}