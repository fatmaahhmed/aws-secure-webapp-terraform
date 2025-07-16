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
output "proxy_alb_dns" {
  description = "DNS name of the public proxy ALB"
  value       = module.alb_proxy.alb_dns_name
}

output "proxy_target_group_arn" {
  description = "Target Group ARN of the proxy ALB"
  value       = module.alb_proxy.target_group_arn
}
# output "proxy_alb_dns" {
#   description = "Public ALB DNS for proxy access"
#   value       = module.alb_proxy.alb_dns_name
# }

output "backend_alb_dns" {
  description = "Internal ALB DNS for backend access"
  value       = module.alb_backend.alb_dns_name
}

output "proxy_instance_public_ips" {
  description = "Public IPs for proxy instances"
  value       = module.ec2_proxy.public_ips
}

output "backend_instance_private_ips" {
  description = "Private IPs for backend instances"
  value       = module.ec2_backend.private_ips
}

output "backend_alb_dns_name" {
  value = module.alb_backend.alb_dns_name
}
