include {
  path = find_in_parent_folders()
}

locals {
  environment_vars = jsondecode(read_tfvars_file("../../../qa.tfvars"))
  aws_region1 = local.environment_vars.region1
  aws_region2 = local.environment_vars.region2
  account_id  = local.environment_vars.account_id
}

generate "main_providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

provider "aws" {
  region = local.aws_region2
}

provider "aws" {
  alias  = local.aws_region2
  region = local.aws_region2
}
EOF
}

terraform {
   source = "${get_parent_terragrunt_dir()}//terraform/wrappers/mrap"
}

inputs = {
  account_id = local.account_id
  aws_region = local.aws_region1
  replica_region = local.aws_region2
}