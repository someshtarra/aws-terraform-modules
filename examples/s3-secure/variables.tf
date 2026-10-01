variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_prefix" {
  description = "Prefix for the secure S3 bucket name"
  type        = string
  default     = "secure-vault-demo-"
}
