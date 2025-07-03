# Create AWS S3 bucket 

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-${var.AWS_REGION}"

  tags = {
    Name        = "MyBucket"
    
  }
}
resource "aws_s3_bucket_acl" "bucket_acl" {
    bucket = aws_s3_bucket.my_bucket.id
    acl    = "private"
}