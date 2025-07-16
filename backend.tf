terraform {
  backend "s3" {
    bucket         = "fatma-terraform-state-2025-1"
    key            = "env/dev/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
