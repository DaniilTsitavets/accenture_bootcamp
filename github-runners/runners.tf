module "github_runner" {
  source  = "github-aws-runners/github-runner/aws"
  version = "~> 6.7.4"

  prefix     = var.prefix
  aws_region = var.aws_region

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  runners_lambda_zip                 = "lambdas/runners.zip"
	webhook_lambda_zip                 = "lambdas/webhook.zip"
	runner_binaries_syncer_lambda_zip  = "lambdas/runner-binaries-syncer.zip"
	ami_housekeeper_lambda_zip         = "lambdas/ami-housekeeper.zip"

  enable_organization_runners = true
  runner_os           = var.runner_os
  runner_architecture = var.runner_arc
  runner_extra_labels = var.runner_labels

  delay_webhook_event       = 0
  enable_job_queued_check   = true
  minimum_running_time_in_minutes = 5

  instance_types = var.instance_types
  ami_owners     = var.ami

  enable_ssm_on_runners = true

  # ----- GitHub App creds -----
  github_app = {
    id_ssm             = "/ghrunners/id"
    key_base64_ssm     = "/ghrunners/key_base64"
    webhook_secret_ssm = "/ghrunners/webhook_secret"
  }

  create_service_linked_role_spot = true

	runner_ec2_tags = {
    Group = var.prefix
  }
}