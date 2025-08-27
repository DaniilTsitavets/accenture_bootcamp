
# Create SNS Topic

module "sns_alerts" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 5.0"

  name = "ecs-alerts-topic"

  subscriptions = [
    { protocol = "email", endpoint = "renatalit@yahoo.com" },
    { protocol = "email", endpoint = "d.tsitavets@gmail.com" }
  ]

  display_name = "ECS Alerts Topic"
}


# Create CloudWatch Alarms


# CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "ecs_cpu" {
  alarm_name          = "ECS-CPU-High"
  alarm_description   = "Triggered when ECS CPU > 80%"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_actions       = [module.sns_alerts.sns_topic_arn]

  dimensions = {
    ClusterName = module.ecs-cluster.name
    ServiceName = module.ecs-service.name
  }
}

# Memory Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "ecs_memory" {
  alarm_name          = "ECS-Memory-High"
  alarm_description   = "Triggered when ECS Memory > 80%"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_actions       = [module.sns_alerts.sns_topic_arn]

  dimensions = {
    ClusterName = module.ecs-cluster.name
    ServiceName = module.ecs-service.name
  }
}

# Running Task Count Alarm
resource "aws_cloudwatch_metric_alarm" "ecs_running_tasks" {
  alarm_name          = "ECS-Running-Task-Count"
  alarm_description   = "Triggered if running tasks < 1"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "RunningTaskCount"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Minimum"
  threshold           = 1
  alarm_actions       = [module.sns_alerts.sns_topic_arn]

  dimensions = {
    ClusterName = module.ecs-cluster.name
    ServiceName = module.ecs-service.name
  }
}

# Desired Task Count Alarm
resource "aws_cloudwatch_metric_alarm" "ecs_desired_tasks" {
  alarm_name          = "ECS-Desired-Task-Count"
  alarm_description   = "Triggered if desired tasks < 1"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "DesiredTaskCount"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Maximum"
  threshold           = 1
  alarm_actions       = [module.sns_alerts.sns_topic_arn]

  dimensions = {
    ClusterName = module.ecs-cluster.name
    ServiceName = module.ecs-service.name
  }
}
