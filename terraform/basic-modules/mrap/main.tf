resource "aws_s3control_multi_region_access_point" "this" {
  details {
    name = "mrap-${var.account_id}"

    region {
      bucket = var.s3_bucket_secondary_id
    }

    region {
      bucket = var.s3_bucket_id
    }
  }
}