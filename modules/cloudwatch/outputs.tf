output "log_group_arn" {
  description = "The ARN of the CloudWatch Log Group"
  value       = try(aws_cloudwatch_log_group.this[0].arn, null)
}

output "log_group_name" {
  description = "The name of the CloudWatch Log Group"
  value       = try(aws_cloudwatch_log_group.this[0].name, null)
}

output "alarm_arns" {
  description = "Map of alarm keys to their ARNs"
  value       = { for k, v in aws_cloudwatch_metric_alarm.this : k => v.arn }
}

output "alarm_names" {
  description = "Map of alarm keys to their names"
  value       = { for k, v in aws_cloudwatch_metric_alarm.this : k => v.alarm_name }
}

output "dashboard_arn" {
  description = "The ARN of the CloudWatch Dashboard"
  value       = try(aws_cloudwatch_dashboard.this[0].dashboard_arn, null)
}
