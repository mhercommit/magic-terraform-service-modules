resource "random_pet" "this" {
  length = 2
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "origin-s3-bucket-${var.account_id}-${var.aws_region}-${random_pet.this.id}"

  versioning = {
    enabled = true
  }

  replication_configuration = {
    role = aws_iam_role.replication.arn

    rules = [
      {
        id       = "replication-rule-${var.account_id}-${var.aws_region}"
        status   = true
        priority = 10

        delete_marker_replication = false

        source_selection_criteria = {
          replica_modifications = {
            status = "Enabled"
          }
          sse_kms_encrypted_objects = {
            enabled = true
          }
        }

        destination = {
          bucket        = "arn:aws:s3:::replica-s3-bucket-${var.account_id}-${var.replica_region}-${random_pet.this.id}"
          storage_class = "STANDARD"

          replica_kms_key_id = aws_kms_key.replica.arn
          account_id         = var.account_id

          access_control_translation = {
            owner = "Destination"
          }

          replication_time = {
            status  = "Enabled"
            minutes = 15
          }

          metrics = {
            status  = "Enabled"
            minutes = 15
          }
        }
      }
    ]
  }
}

module "s3_bucket_replica" {
  source = "terraform-aws-modules/s3-bucket/aws"
  providers = {
    aws = aws.us-west-1
  }

  bucket = "replica-s3-bucket-${var.account_id}-${var.replica_region}-${random_pet.this.id}"

  versioning = {
    enabled = true
  }

  replication_configuration = {
    role = aws_iam_role.replication.arn

    rules = [
      {
        id       = "replication-rule-${var.account_id}-${var.replica_region}"
        status   = true
        priority = 10

        delete_marker_replication = false

        source_selection_criteria = {
          replica_modifications = {
            status = "Enabled"
          }
          sse_kms_encrypted_objects = {
            enabled = true
          }
        }

        destination = {
          bucket        = "arn:aws:s3:::origin-s3-bucket-${var.account_id}-${var.aws_region}-${random_pet.this.id}"
          storage_class = "STANDARD"

          replica_kms_key_id = aws_kms_key.this.arn
          account_id         = var.account_id

          access_control_translation = {
            owner = "Destination"
          }

          replication_time = {
            status  = "Enabled"
            minutes = 15
          }

          metrics = {
            status  = "Enabled"
            minutes = 15
          }
        }
      }
    ]
  }
}