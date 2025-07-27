provider "aws" {
  region = "us-east-1"
}

# --- Bucket to store access logs ---
# We are ignoring the logging check because you don't enable logging on a log bucket.
# tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "log_bucket" {
  bucket = "your-unique-devsecops-log-bucket-2025" # CHANGE TO A UNIQUE NAME
}

# --- Secure the Log Bucket ---
resource "aws_s3_bucket_versioning" "log_bucket_versioning" {
  bucket = aws_s3_bucket.log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
# Ignoring the advanced encryption check for the log bucket. AES256 is sufficient.
# tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket_encryption" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "log_bucket_pab" {
  bucket                  = aws_s3_bucket.log_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --- The main S3 bucket resource ---
resource "aws_s3_bucket" "example" {
  bucket = "your-unique-devsecops-bucket-2025" # CHANGE TO A UNIQUE NAME
}

# --- Secure the Main Bucket ---
resource "aws_s3_bucket_versioning" "example_versioning" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}
# This comment tells tfsec to ignore the recommendation for a customer-managed key.
# tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "example_encryption" {
  bucket = aws_s3_bucket.example.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "example_pab" {
  bucket                  = aws_s3_bucket.example.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_logging" "example_logging" {
  bucket        = aws_s3_bucket.example.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}