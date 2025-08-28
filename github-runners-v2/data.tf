data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["team2-bootcamp-vpc"]
  }
}

data "aws_subnet" "app_subnets" {
  for_each = toset(var.subnet_ids)
  id       = each.value
}

data "aws_security_group" "bastion" {
  filter {
    name   = "tag:Name"
    values = ["team2-bastion-sg"]
  }
  vpc_id = data.aws_vpc.main.id
}
