module "kms" {
  source = "../../modules/kms"

  description             = "KMS Key for S3 Secure Example Bucket"
  alias_name              = "s3-secure-demo-key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Component = "security"
  }
}

module "s3_bucket" {
  source = "../../modules/s3"

  bucket_prefix     = var.bucket_prefix
  versioning_status = "Enabled"

  # Encryption with Customer Managed Key & S3 Bucket Key optimization
  kms_master_key_id  = module.kms.key_arn
  bucket_key_enabled = true

  # Deny HTTP requests via SSL policy
  enforce_ssl = true

  # Block all public ingress
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Automated lifecycle policy
  enable_lifecycle_rules             = true
  noncurrent_version_transition_days = 30
  noncurrent_version_expiration_days = 90

  tags = {
    Component = "storage"
  }
}
