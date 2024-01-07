module "vpc" {
  source = "./vpc-public-module"

  name              = "${var.project_name}-vpc"
  ipv4_ipam_pool_id = data.aws_vpc_ipam_pool.ipv4.id
  cidr              = local.cidr
  azs               = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]

  public_subnets = [
    cidrsubnet(local.cidr, 8, 1),
    cidrsubnet(local.cidr, 8, 2),
    cidrsubnet(local.cidr, 8, 3)
  ]

  private_subnets = [
    cidrsubnet(local.cidr, 8, 11),
    cidrsubnet(local.cidr, 8, 12),
    cidrsubnet(local.cidr, 8, 13)
  ]

  database_subnets = [
    cidrsubnet(local.cidr, 8, 21),
    cidrsubnet(local.cidr, 8, 22),
    cidrsubnet(local.cidr, 8, 23)
  ]

  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_hostnames = true

  private_subnet_tags = {
    Role = "private"
  }

  public_subnet_tags = {
    Role = "public"
  }

  database_subnet_tags = {
    Role = "database"
  }
}

module "vpc_endpoints" {
  source             = "./vpc-public-module//modules/vpc-endpoints"
  vpc_id             = module.vpc.vpc_id
  endpoints = {
    ecr_dkr = {
      service             = "ecr.dkr"
      # policy              = data.aws_iam_policy_document.vpc_endpoint_policy_ecr.json
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    logs = {
      service             = "logs"
      # policy              = data.aws_iam_policy_document.vpc_endpoint_policy_default.json
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    s3 = {
      service             = "s3"
      # policy              = data.aws_iam_policy_document.vpc_endpoint_policy_s3.json
      private_dns_enabled = true
      route_table_ids     = module.vpc.private_route_table_ids
      service_type        = "Gateway"
    },
    secretsmanager = {
      service             = "secretsmanager"
      # policy              = data.aws_iam_policy_document.vpc_endpoint_policy_default.json
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    ssm = {
      service             = "ssm"
      # policy              = data.aws_iam_policy_document.vpc_endpoint_policy_default.json
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
  }
}


resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  subnet_ids         = concat(concat(module.vpc.public_subnets, module.vpc.private_subnets), module.vpc.database_subnets)
  transit_gateway_id = "tgw-070c9f59a24e7383a"
  vpc_id             = module.vpc.vpc_id
}