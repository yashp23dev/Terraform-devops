# Create AWS S3 bucket 

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-${var.AWS_REGION}"
  acl    = "private"

  tags = {
    Name        = "MyBucket"
    
  }
}