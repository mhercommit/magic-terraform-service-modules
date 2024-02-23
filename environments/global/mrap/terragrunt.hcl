include {
  path = find_in_parent_folders()
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  aws_region1 = local.environment_vars.locals.region1
  aws_region2 = local.environment_vars.locals.region2
  account_id = local.environment_vars.locals.account_id
}

generate "main_providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

provider "aws" {
  region = ${local.aws_region1}
}

provider "aws" {
  alias  = "us-west-1"
  region = ${local.aws_region2}
}
EOF
}

terraform {
   source = "${get_parent_terragrunt_dir()}//terraform/wrappers/mrap"
}

inputs = {
  account_id = local.environment_vars.locals.account_id
  aws_region = local.environment_vars.locals.region1
  replica_region = local.environment_vars.locals.region2
}