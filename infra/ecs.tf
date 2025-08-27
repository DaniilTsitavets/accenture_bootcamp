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
  source      = "terraform-aws-modules/ecs/aws//modules/service"
  cluster_arn = module.ecs-cluster.arn
  subnet_ids  = module.vpc.private_subnets
  name        = "team2-wordpress"

  security_group_ids = [module.ecs-sg.security_group_id]
  runtime_platform = {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  create_iam_role           = false
  create_tasks_iam_role     = false
  create_task_exec_iam_role = true
  create_task_exec_policy   = true

  task_exec_iam_role_policies = {
    secrets = module.ecs-task-secrets-policy.arn
  }

  container_definitions = {
    wordpress = {
      cpu                    = 512
      memory                 = 1024
      essential              = true
      image                  = "${module.ecr.repository_url}:${var.image_tag}"
      readonlyRootFilesystem = false

      portMappings = [
        {
          name          = "wordpress"
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
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
          valueFrom = "${tolist(data.aws_secretsmanager_secrets.rds_creds.arns)[0]}:username::"
        },
        {
          name      = "WORDPRESS_DB_PASSWORD"
          valueFrom = "${tolist(data.aws_secretsmanager_secrets.rds_creds.arns)[0]}:password::"
        }
      ]
      create_cloudwatch_log_group = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/aws/ecs/team2-wordpress/wordpress"
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

  enable_autoscaling       = true
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 4
  alarms = null
}