# module "ec2-bastion" {
#   source                      = "terraform-aws-modules/ec2-instance/aws"
#   name                        = "team2-bastion"
#   instance_type               = "t3.micro"
#   ami                         = "ami-09b024e886d7bbe74"
#   key_name                    = "team2-pk"
#   monitoring                  = true
#   subnet_id                   = module.vpc.public_subnets[0]
#   associate_public_ip_address = true
#   create_security_group       = false
#
#   vpc_security_group_ids = [module.ec2-bastion-sg.security_group_id]
#
#   tags = var.tags
# }