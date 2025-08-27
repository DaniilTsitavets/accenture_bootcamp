
# RDS Dashboard
module "rds_dashboard" {
  source  = "HENNGE/cloudwatch-dashboard/aws"


  name = "RDS-team2db-Dashboard"

  widgets = [
    module.rds_cpu.widget_object,
    module.rds_free_storage.widget_object,
    module.rds_db_connections.widget_object,
    module.rds_read_iops.widget_object,
  ]
}

# CPU Utilization widget
module "rds_cpu" {
  source  = "HENNGE/cloudwatch-dashboard/aws//modules/widget/metric"


  namespace  = "AWS/RDS"
  metric     = "CPUUtilization"
dimensions = [{ Name = "DBInstanceIdentifier", Value = module.rds.db_instance_identifier }]
title      = "RDS CPU Utilization (${module.rds.db_instance_identifier})"
stat       = "Average"
}

# Free Storage Space widget
module "rds_free_storage" {
  source  = "HENNGE/cloudwatch-dashboard/aws//modules/widget/metric"


  namespace  = "AWS/RDS"
  metric     = "FreeStorageSpace"
  dimensions = [{ Name = "DBInstanceIdentifier", Value = module.rds.db_instance_identifier }]
  title      = "RDS Free Storage (team2db)"
  stat       = "Minimum"
}

# Database Connections widget
module "rds_db_connections" {
  source  = "HENNGE/cloudwatch-dashboard/aws//modules/widget/metric"
 

  namespace  = "AWS/RDS"
  metric     = "DatabaseConnections"
  dimensions = [{ Name = "DBInstanceIdentifier", Value = module.rds.db_instance_identifier }]
  title      = "RDS Database Connections (team2db)"
  stat       = "Average"
}

# Read IOPS widget
module "rds_read_iops" {
  source  = "HENNGE/cloudwatch-dashboard/aws//modules/widget/metric"


  namespace  = "AWS/RDS"
  metric     = "ReadIOPS"
  dimensions = [{ Name = "DBInstanceIdentifier", Value = module.rds.db_instance_identifier }]
  title      = "RDS Read IOPS (team2db)"
  stat       = "Sum"
}
