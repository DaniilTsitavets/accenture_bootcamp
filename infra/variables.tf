variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "azs" {
  type = list(string)
  description = "Availability zones"
  default = ["eu-west-1a", "eu-west-1b"]
}

variable "private_subnets" {
  type = list(string)
  description = "List of private subnet CIDRs"
}

variable "public_subnets" {
  type = list(string)
  description = "List of public subnet CIDRs"
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "enable_vpn_gateway" {
  type    = bool
  default = false
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

variable "one_nat_gateway_per_az" {
  type    = bool
  default = false
}

variable "manage_default_security_group" {
  type    = bool
  default = false
}

variable "tags" {
  type = map(string)
  description = "Tags to apply to all resources"
}

variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "Region of the infra"
}

variable "image_tag" {
  type        = string
  description = "Tag for ECR image"
}