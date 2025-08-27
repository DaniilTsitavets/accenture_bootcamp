# RDS Dashboard
module "rds_dashboard" {
  source = "HENNGE/cloudwatch-dashboard/aws"
  name   = "RDS-team2db-Dashboard"

  widgets = [
    module.rds_cpu.widget_object,
    module.rds_free_storage.widget_object,
    module.rds_db_connections.widget_object,
    module.rds_read_iops.widget_object,
  ]
}

# CPU Utilization widget
module "rds_cpu" {
  source = "HENNGE/cloudwatch-dashboard/aws//modules/widget/metric"
  title  = "RDS CPU Utilization"
  region = var.region
  width  = 12
  period = 60

  metrics = [
    [
      "AWS/RDS",
      "CPUUtilization",
      "DBInstanceIdentifier", module.rds.db_instance_identifier,
      { stat = "Average" }
    ]
  ]
}

# Free Storage Space widget
module "rds_free_storage" {
  source = "HENNGE/cloudwatch-dashboard/aws//modules/widget/metric"
  title  = "RDS Free Storage (team2db)"
  region = var.region
  width  = 12
  period = 60

  metrics = [
    [
      "AWS/RDS",
      "FreeStorageSpace",
      "DBInstanceIdentifier", module.rds.db_instance_identifier,
      { stat = "Minimum" }
    ]
  ]
}

# Database Connections widget
module "rds_db_connections" {
  source = "HENNGE/cloudwatch-dashboard/aws//modules/widget/metric"
  title  = "RDS Database Connections (team2db)"
  region = var.region
  width  = 12
  period = 60

  metrics = [
    [
      "AWS/RDS",
      "DatabaseConnections",
      "DBInstanceIdentifier", module.rds.db_instance_identifier,
      { stat = "Average" }
    ]
  ]
}

# Read IOPS widget
module "rds_read_iops" {
  source = "HENNGE/cloudwatch-dashboard/aws//modules/widget/metric"
  title  = "RDS Read IOPS (team2db)"
  region = var.region
  width  = 12
  period = 60

  metrics = [
    [
      "AWS/RDS",
      "ReadIOPS",
      "DBInstanceIdentifier", module.rds.db_instance_identifier,
      { stat = "Sum" }
    ]
  ]
}
