# =================================
# EKS
# =================================

module "eks" {
  source  = "./eks-public-module"
  version = "19.5.1"

  cluster_name                   = var.project_name
  cluster_version                = "1.27"
  cluster_endpoint_public_access = true
  enable_irsa                    = true

  kms_key_administrators = ["arn:aws:iam::<account_id>:role/GithubActionsRole"]

  vpc_id     = var.vpc_id
  subnet_ids = local.private_subnet_ids

  tags = merge(local.tags, {
    KubernetesVersion = "1.27"
  })

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::<account_id>:user/OrganizationAccountAccessRole"
      username = "OrgRole"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::<account_id>:role/GithubActionsRole"
      username = "GitHubActions"
      groups   = ["system:masters"]
    }
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::<account_id>:user/"
      username = ""
      groups   = ["system:masters"]
    },
  ]

  # EKS Managed Node Group(s)

  eks_managed_node_group_defaults = {
    create_security_group = false
  }

  eks_managed_node_groups = {
    one = {

      name           = "${var.worker_group_one_name}-${local.env}"
      min_size       = 1
      max_size       = 2
      desired_size   = 2
      instance_types = [var.instance_type_one]
    }
  }
}
