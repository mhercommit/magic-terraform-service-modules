variable "env" {
  type = string
}

variable "cidr" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_route_table_ids" {
  type = list
}

variable "public_route_table_ids" {
  type = list
}

variable "database_route_table_ids" {
  type = list
}

variable "private_subnets" {
  type = list
}