# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region   = local.region_vars.locals.aws_region
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${get_env("TG_BUCKET_PREFIX", "")}terragrunt-terraform-state-${local.account_name}-${local.aws_region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# ---------------------------------------------------------------------------------------------------------------------
inputs = merge(
  local.region_vars.locals
)