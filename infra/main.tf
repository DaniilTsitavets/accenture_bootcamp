provider "aws" {
  region  = var.region
  profile = "dev-mfa"
}

# terraform {
#   backend "s3" {
#     bucket = ""
#     use_lockfile = true
#     key    = "infra/"
#     region = "eu-west-1"
#   }
# }
