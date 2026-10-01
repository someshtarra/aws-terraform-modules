output "function_arn" {
  description = "The Amazon Resource Name (ARN) identifying your Lambda Function"
  value       = aws_lambda_function.this.arn
}

output "function_name" {
  description = "The unique name of the Lambda Function"
  value       = aws_lambda_function.this.function_name
}

output "function_invoke_arn" {
  description = "The ARN to be used for invoking Lambda Function from API Gateway"
  value       = aws_lambda_function.this.invoke_arn
}

output "role_arn" {
  description = "The ARN of the IAM role created for the Lambda function"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "The name of the IAM role created for the Lambda function"
  value       = aws_iam_role.this.name
}

output "log_group_arn" {
  description = "The ARN of the CloudWatch Log Group for the function"
  value       = aws_cloudwatch_log_group.this.arn
}
