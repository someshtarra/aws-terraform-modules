output "role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.this.name
}

output "role_id" {
  description = "The unique ID of the IAM role"
  value       = aws_iam_role.this.id
}

output "instance_profile_arn" {
  description = "The ARN of the IAM instance profile"
  value       = try(aws_iam_instance_profile.this[0].arn, null)
}

output "instance_profile_name" {
  description = "The name of the IAM instance profile"
  value       = try(aws_iam_instance_profile.this[0].name, null)
}

output "custom_policy_arn" {
  description = "The ARN of the custom IAM policy created, if any"
  value       = try(aws_iam_policy.custom[0].arn, null)
}
