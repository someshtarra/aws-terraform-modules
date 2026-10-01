output "bucket_id" {
  description = "The name of the provisioned secure S3 bucket"
  value       = module.s3_bucket.bucket_id
}

output "bucket_arn" {
  description = "The ARN of the secure S3 bucket"
  value       = module.s3_bucket.bucket_arn
}

output "kms_key_arn" {
  description = "The ARN of the KMS key used for bucket encryption"
  value       = module.kms.key_arn
}
