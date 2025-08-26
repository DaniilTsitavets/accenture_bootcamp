region       = "eu-west-1"
# S3 backend(without prefix)
# Used ONLY once in network block in other blocks you must use output from network block
# bucket_name = "team2-bucket"

# VPC vars
vpc_name = "team2-bootcamp-vpc"
vpc_cidr = "10.0.0.0/16"

private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

# Tags
tags = {
  Terraform   = "true"
  Environment = "dev"
}
