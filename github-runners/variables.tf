variable "aws_region" {
  type    = string
}

variable "environment" {
  description = "Environment (e.g. dev, stage, prod)"
  type        = string
}

variable "prefix" {
	description = "Infrastructure environment ('github-runners' as an example)"
  type    = string
}

variable "group" {
	description = "Accenture Bootcamp 2025 group name/number"
  type    = string
}


# ----- VPC inputs -----
variable "vpc_cidr" {
  type    = string
}

variable "azs" {
  type    = list(string)
}

variable "public_subnets" {
  type    = list(string)
}

variable "private_subnets" {
  type    = list(string)
}


# ----- Runner settings -----
variable "runner_os" {
	type = string
}

variable "runner_arc" {
	type = string
}

variable "ami" {
	type = list(string)
}

variable "instance_types" {
  type    = list(string)
}

variable "runner_labels" {
  type    = list(string)
}
