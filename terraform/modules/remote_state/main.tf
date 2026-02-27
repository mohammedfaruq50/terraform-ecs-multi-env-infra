provider "aws" {
  region = var.region
}

# S3 bucket for Terraform state
resource "aws_s3_bucket" "state_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name = "TerraformStateBucket"
    Env  = var.environment
  }
}

# # DynamoDB table for state locking
# resource "aws_dynamodb_table" "lock_table" {
#   name         = var.lock_table_name
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     Name = "TerraformLockTable"
#     Env  = var.environment
#   }
# }
