output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "The ARN of the EC2 instance"
  value       = aws_instance.this.arn
}

output "private_ip" {
  description = "The private IP address assigned to the instance"
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable"
  value       = aws_instance.this.public_ip
}

output "security_group_id" {
  description = "The ID of the security group created for the instance"
  value       = try(aws_security_group.this[0].id, null)
}

output "security_group_arn" {
  description = "The ARN of the security group created for the instance"
  value       = try(aws_security_group.this[0].arn, null)
}

output "key_pair_name" {
  description = "The key pair name used for the instance"
  value       = local.key_name
}

output "additional_ebs_volume_id" {
  description = "The ID of the additional EBS volume created, if any"
  value       = try(aws_ebs_volume.additional[0].id, null)
}
