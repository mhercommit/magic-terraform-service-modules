# =================================
# General
# =================================
variable "aws_region" {
  type = string
}

variable "env" {
  type = string
}

variable "project_name" {
  type = string
}

variable "instance_type_one" {
  type = string
}

variable "worker_group_one_name" {
  type = string
}

variable "subnet_ids" {
}

variable "vpc_id" {
}