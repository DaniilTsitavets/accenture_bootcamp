# ------------ Infra ------------

variable "aws_region" {
  type    = string
}

variable "prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

# ------------ Runner ------------

variable "github_owner" { 
	type = string 
}

variable "github_repo"  { 
	type = string 
}

variable "github_pat_ssm_parameter_name" {
  type    = string
}

variable "runner_labels" { 
	type = string
	default = "self-hosted,Linux,ec2" 
}

variable "runner_prefix" { 
	type = string
	default = "gh-runner" 
}

variable "instance_type" { 
	type = string 
	default = "t3.medium" 
}

variable "ephemeral" {
	type = bool
	default = false
}