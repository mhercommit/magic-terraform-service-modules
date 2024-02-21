module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = "vpc-${var.env}"
  cidr = var.cidr
  azs  = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]

  public_subnets = [
    cidrsubnet(var.cidr, 8, 1),
    cidrsubnet(var.cidr, 8, 2),
    cidrsubnet(var.cidr, 8, 3)
  ]

  private_subnets = [
    cidrsubnet(var.cidr, 8, 11),
    cidrsubnet(var.cidr, 8, 12),
    cidrsubnet(var.cidr, 8, 13)
  ]

  database_subnets = [
    cidrsubnet(var.cidr, 8, 21),
    cidrsubnet(var.cidr, 8, 22),
    cidrsubnet(var.cidr, 8, 23)
  ]


  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  create_database_subnet_route_table = true

  private_subnet_names = ["net-${var.env}-private-az1", "net-${var.env}-private-az2","net-${var.env}-private-az3"]
  public_subnet_names  = ["net-${var.env}-public-az1", "net-${var.env}-public-az2", "net-${var.env}-public-az3"]
  database_subnet_names = ["net-${var.env}-data-az1", "net-${var.env}-data-az2", "net-${var.env}-data-az3"]

  vpc_tags = {
    Name = "vpc-${var.env}"
  }
  igw_tags = {
    Name = "igw-${var.env}"
  }


  default_route_table_tags = {
    Name = "rtb-${var.env}-default"
  } 
  public_route_table_tags = {
    Name = "rtb-${var.env}-public"
  } 
  private_route_table_tags = {
    Name = "rtb-${var.env}-private"
  } 
  database_route_table_tags = {
    Name = "rtb-${var.env}-data"
  } 
}