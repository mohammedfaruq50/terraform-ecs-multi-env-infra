output "bucket_name" {
  value = aws_s3_bucket.state_bucket.id
}

# output "lock_table_name" {
#   value = aws_dynamodb_table.lock_table.id
# }
