# Find the pool RAM shared to your account
# Info on RAM sharing pools: https://docs.aws.amazon.com/vpc/latest/ipam/share-pool-ipam.html
data "aws_vpc_ipam_pool" "ipv4" {
  filter {
    name   = "description"
    values = ["*Ireland pool*"]
  }
}

# Preview next CIDR from pool
data "aws_vpc_ipam_preview_next_cidr" "previewed_cidr" {
  ipam_pool_id   = data.aws_vpc_ipam_pool.ipv4.id
  netmask_length = 24
}