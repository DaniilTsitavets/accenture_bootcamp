aws_region  = "eu-west-1"
prefix      = "github-runners"
group       = "team-2"
environment = "prod"

vpc_cidr        = "10.42.0.0/16"
azs             = ["eu-west-1a", "eu-west-1b"]
private_subnets = ["10.42.1.0/24", "10.42.2.0/24"]
public_subnets  = ["10.42.101.0/24", "10.42.102.0/24"]


instance_types     = ["t3.medium"]
runner_labels = ["self-hosted", "amazon", "ephemeral"]
ami                 = ["amazon"]
runner_arc          = "x64"
runner_os           = "linux"

github_app_id = "0"
github_app_key_base64 = "dummy"
github_webhook_secret = "dummy"