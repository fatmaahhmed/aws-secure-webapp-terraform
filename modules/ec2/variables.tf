variable "name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs"
}



variable "key_name" {
  type = string
}

variable "user_data" {
  type    = string
  default = ""
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "attach_to_alb" {
  type    = bool
  default = false
}

variable "target_group_arn" {
  type    = string
  default = ""
}

variable "app_port" {
  type    = number
  default = 80
}
