data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com","edgelambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  name               = "role-for-lambda-${var.account_id}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  inline_policy {
    name = "policy-s3-cloudwatch-policy-${var.account_id}"

    policy = jsonencode({
      Version   = "2012-10-17",
      Statement = [
        {
          Effect   = "Allow",
          Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
          Resource = ["arn:aws:logs:*:202238112620:log-group:*"]
        },
        {
          Effect   = "Allow",
          Action   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"],
          Resource = [
            "${var.s3_bucket_arn}/*",
            "${var.s3_secondary_bucket_arn}/*",
            var.s3_bucket_arn,
            var.s3_secondary_bucket_arn
          ]
        },
      ],
    })
  }
}

resource "aws_lambda_function" "this" {
  publish       = true
  filename      = "lambda-deployment-package.zip"
  function_name = "lambda-function-${var.account_id}"
  role          = aws_iam_role.this.arn
  handler       = "index.handler"

  runtime       = "nodejs14.x"
}