terraform {
	backend "s3" {
    bucket         = "team2-backend-2025-aug"
    key            = "github-runners-v2.tfstate"
    region         = "eu-west-1"
    profile        = "dev-mfa"
  }
}

provider "aws" {
  region = var.aws_region
}

