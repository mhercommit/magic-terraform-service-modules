module "s3" {
  source         = "../../basic-modules/s3"
  account_id     = var.account_id
  aws_region     = var.aws_region
  replica_region = var.replica_region
}

module "mrap" {
  source                 = "../../basicmodules/mrap"
  account_id             = var.account_id
  s3_bucket_secondary_id = module.s3.secondary_bucket_id
  s3_bucket_id           = module.s3.primary_bucket_id
}

module "lambda" {
  source                 = "../../basic-modules/lambda"
  account_id             = var.account_id
  s3_secondary_bucket_arn = module.s3.secondary_bucket_arn
  s3_bucket_arn           = module.s3.primary_bucket_arn
}

module "cloudfront" {
  source                 = "../../basic-modules/cloudfront"
  account_id             = var.account_id
  lammbda_function_arn   = module.lambda.lambda_function_arn
  lammbda_function_version = module.lambda.lambda_function_version
  mrap_alias = module.mrap.mrap_alias
}