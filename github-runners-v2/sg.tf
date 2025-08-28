resource "aws_security_group" "runner" {
  name        = "${var.environment}-${var.prefix}-sg"
  description = "No inbound; all egress for GitHub runner"
  vpc_id      = local.vpc_id

  ingress {
    description = "SSH from bastion hosts only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [data.aws_security_group.bastion.id]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = { 
    Name = "${var.environment}-${var.prefix}-sg" 
    Group = "${var.prefix}"
    }
}