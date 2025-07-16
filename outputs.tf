output "bucket_name" {
  value = module.remote_state.bucket_id
}
output "bucket_arn" {
  value = module.remote_state.bucket_arn
}
output "dynamodb_table_name" {
  value = module.remote_state.table_name
}
output "dynamodb_table_arn" {
  value = module.remote_state.table_arn
}
output "vpc_id" {
  value = module.vpc.vpc_id
}
