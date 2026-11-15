output "instance_id" {
  value = aws_instance.this.id
}

output "public_ip" {
  description = "Empty when launched into a private subnet. Changes if the instance is stopped and started."
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  value = aws_instance.this.private_ip
}

output "security_group_id" {
  value = aws_security_group.this.id
}

output "role_name" {
  value = aws_iam_role.this.name
}
