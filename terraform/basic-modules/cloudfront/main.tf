resource "aws_cloudfront_public_key" "this" {
  encoded_key = file("public_key.pem")
  name        = "cloudfront-public-key-${var.account_id}"

  lifecycle {
   ignore_changes = [ true ] 
  }
}

resource "aws_cloudfront_key_group" "this" {
  items   = [aws_cloudfront_public_key.this.id]
  name    = "cloudfront-key-group-${var.account_id}"
}

module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket_one = "My awesome CloudFront can access"
  }
  origin = {
    something = {
    domain_name = "${var.mrap_alias}.accesspoint.s3-global.amazonaws.com"
    origin_id   = "s3-mrap-origin-${var.account_id}"
    custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }

  }
  default_cache_behavior = {
    target_origin_id           = "s3-mrap-origin-${var.account_id}"
    viewer_protocol_policy     = "allow-all"
    trusted_key_groups =        [aws_cloudfront_key_group.this.id]

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true

    lambda_function_association = {
      origin-request : {
        lambda_arn : "${var.lammbda_function_arn}:${var.lammbda_function_version}"
      } 
    }
  }

  viewer_certificate = {
    cloudfront_default_certificate = true
  }
}