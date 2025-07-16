output "bucket_id" {
  value = aws_s3_bucket.tf_state.id
}

output "bucket_arn" {
  value = aws_s3_bucket.tf_state.arn
}

output "table_name" {
  value = aws_dynamodb_table.tf_lock.id
}

output "table_arn" {
  value = aws_dynamodb_table.tf_lock.arn
}
