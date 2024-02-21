output "primary_bucket_id" {
  value = module.s3_bucket.s3_bucket_id
}

output "secondary_bucket_id" {
  value = module.s3_bucket_replica.s3_bucket_id
}

output "primary_bucket_arn" {
  value = module.s3_bucket.s3_bucket_arn
}

output "secondary_bucket_arn" {
  value = module.s3_bucket_replica.s3_bucket_arn
}