resource "aws_iam_role" "replication" {
  name = "role-s3-bucket-replication-${var.account_id}-${random_pet.this.id}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication" {
  name = "policy-s3-bucket-replication-${var.account_id}-${random_pet.this.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::origin-s3-bucket-${var.account_id}-${var.aws_region}-${random_pet.this.id}",
        "arn:aws:s3:::replica-s3-bucket-${var.account_id}-${var.replica_region}-${random_pet.this.id}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::origin-s3-bucket-${var.account_id}-${var.aws_region}-${random_pet.this.id}/*",
        "arn:aws:s3:::replica-s3-bucket-${var.account_id}-${var.replica_region}-${random_pet.this.id}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::origin-s3-bucket-${var.account_id}-${var.aws_region}-${random_pet.this.id}/*",
        "arn:aws:s3:::replica-s3-bucket-${var.account_id}-${var.replica_region}-${random_pet.this.id}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "replication" {
  name       = "s3-bucket-replication-${random_pet.this.id}"
  roles      = [aws_iam_role.replication.name]
  policy_arn = aws_iam_policy.replication.arn
}