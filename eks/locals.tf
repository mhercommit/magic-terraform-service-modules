locals {
  private_subnet_ids = jsondecode(var.subnet_ids)
  env                = var.env

  tags = {
    Environment = var.env
    Project     = var.project_name
    Automation  = "terraform-terragrunt"
  }
}
