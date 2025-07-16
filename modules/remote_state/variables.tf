variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket for Terraform state"
}

variable "dynamodb_table_name" {
  type        = string
  description = "The name of the DynamoDB table for Terraform state locking"
}
