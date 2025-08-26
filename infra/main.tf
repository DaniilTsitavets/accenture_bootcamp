provider "aws" {
  region  = var.region
  profile = "dev-mfa"
}

terraform {
  backend "s3" {
    bucket = "team2-backend-2025-aug"
    use_lockfile = true
    key    = "infra/state"
    region = "eu-west-1"
  }
}
