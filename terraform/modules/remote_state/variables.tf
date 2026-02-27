variable "bucket_name" {
  description = "Name of the S3 bucket to store Terraform state"
  type        = string
}

# variable "lock_table_name" {
#   description = "Name of the DynamoDB table for locking"
#   type        = string
# }

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment (dev/prod)"
  type        = string
  default     = "dev"
}
