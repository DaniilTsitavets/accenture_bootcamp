aws_region  = "eu-west-1"
prefix      = "team-2"
environment = "github-runner"

subnet_ids = ["subnet-01c52171b029279af", "subnet-0b2f4c9517661be35"]

github_pat_ssm_parameter_name = "/github/pat"
github_owner = "DaniilTsitavets"
github_repo = "accenture_bootcamp"