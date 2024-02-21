resource "aws_kms_key" "replica" {
  provider = aws.us-west-1

  description             = "S3 bucket replication KMS key"
  deletion_window_in_days = 7
}

resource "aws_kms_key" "this" {

  description             = "S3 bucket replication KMS key"
  deletion_window_in_days = 7
}