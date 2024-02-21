output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "database_subnet_ids" {
  value = module.vpc.database_subnets
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

output "database_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

output "private_subnets" {
  value = module.vpc.private_subnets
}