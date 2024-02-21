module "vpc" {
  source       = "../../basic-modules/vpc"
  aws_region   = var.aws_region
  cidr         = var.cidr
  env          = var.env
}


module "vpc-endpoint" {
  source       = "../../basic-modules/vpc-endpoints"
  cidr         = var.cidr
  env          = var.env
  vpc_id       = module.vpc.vpc_id
  private_route_table_ids = module.vpc.private_route_table_ids
  public_route_table_ids = module.vpc.public_route_table_ids
  database_route_table_ids = module.vpc.database_route_table_ids
  private_subnets = module.vpc.private_subnets
}
