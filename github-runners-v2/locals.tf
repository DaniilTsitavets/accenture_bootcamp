locals {
  vpc_id            = data.aws_subnet.app_subnets[tolist(keys(data.aws_subnet.app_subnets))[0]].vpc_id
  subnet_ids_unique = tolist(toset(var.subnet_ids))
}