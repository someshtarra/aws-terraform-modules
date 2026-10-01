variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "db_password" {
  description = "Master password for the RDS database (min 8 characters)"
  type        = string
  sensitive   = true
  default     = "ChangeMeSecurePassword123!"
}
