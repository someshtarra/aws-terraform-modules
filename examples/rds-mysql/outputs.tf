output "rds_endpoint" {
  description = "The database connection endpoint"
  value       = module.rds_mysql.db_instance_endpoint
}

output "rds_address" {
  description = "The hostname of the RDS instance"
  value       = module.rds_mysql.db_instance_address
}

output "rds_port" {
  description = "The port the database is listening on"
  value       = module.rds_mysql.db_instance_port
}

output "kms_key_arn" {
  description = "The KMS key ARN encrypting the database"
  value       = module.kms.key_arn
}
