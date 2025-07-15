output "bucket_name" {
  description = "S3 Bucket name"
  value       = module.s3_bucket.bucket_id
}

output "bucket_arn" {
  description = "S3 Bucket ARN"
  value       = module.s3_bucket.bucket_arn
}

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = module.dynamodb_table.table_name
}

output "dynamodb_table_arn" {
  description = "DynamoDB table ARN"
  value       = module.dynamodb_table.table_arn
}

