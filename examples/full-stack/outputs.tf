output "alb_dns_name" {
  description = "Public entry point: DNS name of Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "vpc_id" {
  description = "The ID of the provisioned VPC"
  value       = module.vpc.vpc_id
}

output "ec2_private_ip" {
  description = "Private IP address of the EC2 application instance"
  value       = module.ec2_app.private_ip
}

output "rds_endpoint" {
  description = "Connection endpoint for the RDS database"
  value       = module.rds.db_instance_endpoint
}

output "s3_bucket_id" {
  description = "Secure S3 bucket name"
  value       = module.s3_assets.bucket_id
}

output "kms_key_arn" {
  description = "KMS Customer Managed Key ARN encrypting storage across stack"
  value       = module.kms.key_arn
}

output "cloudwatch_dashboard_arn" {
  description = "ARN of the provisioned CloudWatch operational dashboard"
  value       = module.cloudwatch.dashboard_arn
}
