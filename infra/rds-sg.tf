module "rds-sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "team2-rds-sg"
  description = "Security for RDS to allow acess from bastion and ECS nodes"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      source_security_group_id = module.ec2-bastion-sg.security_group_id
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}