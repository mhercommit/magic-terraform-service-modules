locals {
  env = var.env

  tags = {
    Environment = var.env
    Project     = var.project_name
    Automation  = "terraform-terragrunt"
  }
  cidr = data.aws_vpc_ipam_preview_next_cidr.previewed_cidr.cidr
}
