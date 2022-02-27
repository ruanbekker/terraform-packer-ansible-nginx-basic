variable "aws_profile" {
  type        = string
  description = "aws profile"
}

variable "aws_region" {
  type        = string
  description = "aws region"
}

variable "team_name" {
  type        = string
  description = "owner of the resource"
}

variable "project_name" {
  type        = string
  description = "project name, eg. my-website"
}

variable "environment_name" {
  type        = string
  description = "environment, eg. prod, staging, dev"
}

variable "ami_prefix" {
  type        = string
  description = "prefix of the name of the ami that should be launched"
}

variable "instance_type" {
  type        = string
  description = "ec2 instance type"
}

variable "ssh_key_name" {
  type        = string
  description = "ec2 ssh key"
}


variable "vpc_name" {
    type        = string
    default     = "main"
    description = "the vpc name"
}

variable "network_tier" {
    type        = string
    default     = "public"
    description = "the tier tag value used to identify public subnets"
}
