# main.tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "your-unique-devsecops-bucket-2025" # Change to a unique name
  
  # WARNING: This line is insecure and will be flagged by tfsec.
  acl = "public-read" 
}