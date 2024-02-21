include {
  path = find_in_parent_folders()
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  aws_region       = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  env    = local.environment_vars.locals.environment
  region = local.aws_region.locals.aws_region
  account_id = local.account_vars.locals.aws_account_id
}

terraform {
  source = "git::git@github.com:communityct/aws-tf-networking.git"
}

inputs = {
  cidr = "10.20.0.0/16"
  aws_region = local.region
  env = local.env
}