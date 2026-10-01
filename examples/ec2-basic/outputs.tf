output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "public_ip" {
  description = "Public IP address of the instance"
  value       = module.ec2.public_ip
}

output "security_group_id" {
  description = "ID of the generated security group"
  value       = module.ec2.security_group_id
}
