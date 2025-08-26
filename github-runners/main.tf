terraform {
	backend "s3" {
    bucket         = "team2-backend-2025-aug"
    key            = "github-runners.tfstate"
    region         = var.aws_region
  }
}

provider "aws" {
  region = var.aws_region
}

