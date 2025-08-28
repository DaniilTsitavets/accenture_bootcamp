# Create SNS Topic
module "sns_alerts" {
  source  = "terraform-aws-modules/sns/aws"
  name = "ecs-topic"
  subscriptions = [
    { protocol = "email", endpoint = "renatalit@yahoo.com" },
    { protocol = "email", endpoint = "d.tsitavets@gmail.com" }
  ]
  display_name = "ECS Alerts Topic"
}

module "cpu_scale_up_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  alarm_name          = "team2-cpu-scale-up-alarm"
  alarm_description   = "Triggers than fargate scales because of CPU threshold overcome"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  threshold           = 75
  period              = 60
  unit                = "Percent"

  namespace   = "AWS/ECS"
  dimensions = {
    ClusterName = module.ecs-cluster.name
    ServiceName = module.ecs-service.name
  }
  metric_name = "CPUUtilization"
  statistic   = "Average"

  alarm_actions = [module.sns_alerts.topic_arn]
}

module "memory_scale_up_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  alarm_name          = "team2-memory-scale-up-alarm"
  alarm_description   = "Triggers than fargate scales because of Memory Utilization threshold overcome"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  threshold           = 75
  period              = 60
  unit                = "Percent"

  namespace   = "AWS/ECS"
  dimensions = {
    ClusterName = module.ecs-cluster.name
    ServiceName = module.ecs-service.name
  }
  metric_name = "MemoryUtilization"
  statistic   = "Average"

    alarm_actions = [module.sns_alerts.topic_arn]
}