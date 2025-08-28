module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.5"

  name = "${var.prefix}-vpc-${var.group}"
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Group = var.prefix
  }
}