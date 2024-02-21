module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.5.1"
  vpc_id             = var.vpc_id
  security_group_ids = [module.sg-vpc-endpoint.security_group_id]
  endpoints          = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = flatten([
        var.private_route_table_ids,var.public_route_table_ids, var.database_route_table_ids
      ])
      tags = { Name = "vpce-gateway-${var.env}-s3" }
    },
    logs = {
      service             = "logs"
      private_dns_enabled = true
      subnet_ids          = var.private_subnets
      tags                = { Name = "vpce-interface-${var.env}-logs" }
    }
    ecr-api = {
      service             = "ecr.api"
      private_dns_enabled = true
      subnet_ids          = var.private_subnets
      tags                = { Name = "vpce-interface-${var.env}-ecr-api" }
    },
    ecr-dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = var.private_subnets
      tags                = { Name = "vpce-interface-${var.env}-ecr-dkr" }
    },
    ec2 = {
      service             = "ec2"
      private_dns_enabled = true
      subnet_ids          = var.private_subnets
      tags                = { Name = "vpce-interface-${var.env}-ec2" }
    },
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = var.private_subnets
      tags                = { Name = "vpce-interface-${var.env}-ssm" }
    }
    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
      subnet_ids          = var.private_subnets
      tags                = { Name = "vpce-interface-${var.env}-ec2messages" }
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = var.private_subnets
      tags                = { Name = "vpce-interface-${var.env}-ssmmessages" }
    }
  }
  tags = {
    service        = "networking",
  }
}

module "sg-vpc-endpoint" {
 source  = "terraform-aws-modules/security-group/aws"
 version = "5.1.0"
 name = "sgr-${var.env}-vpc-endpoints"

 description     = "Security group for VPC endpoints"
 vpc_id          = var.vpc_id
 use_name_prefix = false

 ingress_cidr_blocks     = [var.cidr]
 ingress_rules           = ["all-all"]
 egress_cidr_blocks      = ["0.0.0.0/0"]
 egress_ipv6_cidr_blocks = []
 egress_rules            = ["all-all"]

 tags = {
   Name           = "sgr-${var.env}-vpc-endpoints"
   service        = "networking",
 }
}