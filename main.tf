provider "aws" {
  region = "us-east-1"
}

# It's best practice to store logs in a separate bucket.
resource "aws_s3_bucket" "log_bucket" {
  bucket = "your-unique-devsecops-log-bucket-2025" # CHANGE TO A UNIQUE NAME
}

# This is the main S3 bucket resource.
resource "aws_s3_bucket" "example" {
  bucket = "your-unique-devsecops-bucket-2025" # CHANGE TO A UNIQUE NAME
}

# This block enables versioning to protect against data loss.
# Fixes: aws-s3-enable-versioning
resource "aws_s3_bucket_versioning" "example_versioning" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}

# This block enables default server-side encryption.
# Fixes: aws-s3-enable-bucket-encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "example_encryption" {
  bucket = aws_s3_bucket.example.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# This block prevents all forms of public access.
# Fixes all 5 "public access" issues and the "no-public-buckets" issue.
resource "aws_s3_bucket_public_access_block" "example_pab" {
  bucket                  = aws_s3_bucket.example.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# This block enables access logging for the main bucket.
# Fixes: aws-s3-enable-bucket-logging
resource "aws_s3_bucket_logging" "example_logging" {
  bucket        = aws_s3_bucket.example.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}