# ECS Dashboard
module "ecs_dashboard" {
  source = "HENNGE/cloudwatch-dashboard/aws"
  name   = "ECS-Tasks-Dashboard"
  widgets = [
    module.ecs_cpu.widget_object,
    module.ecs_memory.widget_object,
    module.ecs_running_tasks.widget_object,
    module.ecs_desired_tasks.widget_object,
  ]
}

# CPU Utilization widget
module "ecs_cpu" {
  source = "HENNGE/cloudwatch-dashboard/aws//modules/widget/metric"
  region = var.region
  title  = "ECS CPU Utilization"
  width  = 12
  period = 60

  metrics = [
    [
      "AWS/ECS",
      "CPUUtilization",
      "ClusterName", module.ecs-cluster.name,
      "ServiceName", module.ecs-service.name,
      { stat = "Average" }
    ]
  ]
}

# Memory Utilization widget
module "ecs_memory" {
  source = "HENNGE/cloudwatch-dashboard/aws//modules/widget/metric"
  region = var.region
  title  = "ECS Memory Utilization"
  width  = 12
  period = 60

  metrics = [
    [
      "AWS/ECS",
      "MemoryUtilization",
      "ClusterName", module.ecs-cluster.name,
      "ServiceName", module.ecs-service.name,
      { stat = "Average" }
    ]
  ]
}

# Running Task Count widget
module "ecs_running_tasks" {
  source = "HENNGE/cloudwatch-dashboard/aws//modules/widget/metric"
  region = var.region
  title  = "ECS Running Task Count"
  width  = 12
  period = 60

  metrics = [
    [
      "ECS/ContainerInsights",
      "RunningTaskCount",
      "ClusterName", module.ecs-cluster.name,
      "ServiceName", module.ecs-service.name,
      { stat = "Maximum" }
    ]
  ]
}

# Desired Task Count widget
module "ecs_desired_tasks" {
  source = "HENNGE/cloudwatch-dashboard/aws//modules/widget/metric"
  region = var.region
  title  = "ECS Desired Task Count"
  width  = 12
  period = 60

  metrics = [
    [
      "ECS/ContainerInsights",
      "DesiredTaskCount",
      "ClusterName", module.ecs-cluster.name,
      "ServiceName", module.ecs-service.name,
      { stat = "Maximum" }
    ]
  ]
}
