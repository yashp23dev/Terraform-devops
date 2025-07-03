# Roles to access AWS S3 bucket

resource "aws_iam_role" "s3_access_role" {
  name = "s3_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Sid = ""
      },
    ]
  })
}

# Policy to attach to the role for S3 access

resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3_access_policy"
  description = "Policy to allow access to S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${aws_s3_bucket.my_bucket.arn}/*",
          aws_s3_bucket.my_bucket.arn
        ]
      },
    ]
  })
}

# Instance identifier profile

resource "aws_iam_instance_profile" "s3_access_instance_profile" {
  name = "s3_access_instance_profile"
  role = aws_iam_role.s3_access_role.name
}

