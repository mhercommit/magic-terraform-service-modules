output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "oidc_provider" {
  value = module.eks.oidc_provider
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "kms_arn" {
  value = aws_kms_key.key.arn
}

output "kms_role" {
  value = aws_iam_role.kms_read_only_role.arn
}



