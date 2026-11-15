output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "app_bucket" {
  value = module.app_bucket.bucket_name
}

output "web_instance_id" {
  description = "aws ssm start-session --target <this> for a shell."
  value       = module.web.instance_id
}

output "web_url" {
  value = module.web.public_ip != "" ? "http://${module.web.public_ip}" : null
}
