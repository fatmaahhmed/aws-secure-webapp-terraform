# terraform {
#   backend "s3" {
#     bucket         = "my-terraform-state-bucket"
#     key            = "env/dev/terraform.tfstate"
#     region         = "us-east-2"
#     dynamodb_table = "my-terraform-locks"
#     encrypt        = true
#   }
# }
