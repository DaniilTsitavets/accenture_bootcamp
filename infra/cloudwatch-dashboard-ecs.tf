
# ECS Dashboard
module "ecs_dashboard" {
  source  = "HENNGE/cloudwatch-dashboard/aws"
 
  name = "ECS-Tasks-Dashboard"

  widgets = [
    module.ecs_cpu.widget_object,
    module.ecs_memory.widget_object,
    module.ecs_running_tasks.widget_object,
    module.ecs_desired_tasks.widget_object,
  ]
}

# CPU Utilization widget
module "ecs_cpu" {
  source  = "HENNGE/cloudwatch-dashboard/aws//modules/widget/metric"

  namespace  = "AWS/ECS"
  metric     = "CPUUtilization"
dimensions = [
    { Name = "ClusterName", Value = module.ecs-cluster.name },
    { Name = "ServiceName", Value = module.ecs-service.name }
  ]
  title      = "ECS CPU Utilization"
  stat       = "Average"
}

# Memory Utilization widget
module "ecs_memory" {
  source  = "HENNGE/cloudwatch-dashboard/aws//modules/widget/metric"

  namespace  = "AWS/ECS"
  metric     = "MemoryUtilization"
  dimensions = [
    { Name = "ClusterName", Value = module.ecs-cluster.name },
    { Name = "ServiceName", Value = module.ecs-service.name }
  ]
  title      = "ECS Memory Utilization"
  stat       = "Average"
}

# Running Task Count widget
module "ecs_running_tasks" {
  source  = "HENNGE/cloudwatch-dashboard/aws//modules/widget/metric"

  namespace  = "AWS/ECS"
  metric     = "RunningTaskCount"
  dimensions = [
    { Name = "ClusterName", Value = module.ecs-cluster.name },
    { Name = "ServiceName", Value = module.ecs-service.name }
  ]
  title      = "ECS Running Task Count"
  stat       = "Maximum"
}

# Desired Task Count widget
module "ecs_desired_tasks" {
  source  = "HENNGE/cloudwatch-dashboard/aws//modules/widget/metric"


  namespace  = "AWS/ECS"
  metric     = "DesiredTaskCount"
  dimensions = [
    { Name = "ClusterName", Value = module.ecs-cluster.name },
    { Name = "ServiceName", Value = module.ecs-service.name }
  ]
  title      = "ECS Desired Task Count"
  stat       = "Maximum"
}
