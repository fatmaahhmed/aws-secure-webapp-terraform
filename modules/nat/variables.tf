variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_id" {
  type        = string
  description = "One public subnet to place the NAT Gateway in"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs to associate with the NAT route table"
}

variable "name" {
  type        = string
  description = "Name prefix for tagging"
}
