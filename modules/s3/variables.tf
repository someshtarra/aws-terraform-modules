variable "bucket_name" {
  description = "The name of the bucket. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "bucket_prefix" {
  description = "Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket_name."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error (these objects are not recoverable)"
  type        = bool
  default     = false
}

variable "versioning_status" {
  description = "The versioning state of the bucket. Valid values: Enabled, Suspended, or Disabled"
  type        = string
  default     = "Enabled"
  validation {
    condition     = contains(["Enabled", "Suspended", "Disabled"], var.versioning_status)
    error_message = "versioning_status must be Enabled, Suspended, or Disabled."
  }
}

variable "kms_master_key_id" {
  description = "The AWS KMS master key ID or ARN used for the SSE-KMS encryption. If null, AES256 server-side encryption is used."
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Whether or not to use Amazon S3 Bucket Keys for SSE-KMS. Reduces KMS request costs by up to 99%."
  type        = bool
  default     = true
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "object_ownership" {
  description = "Object ownership rule. Valid values: BucketOwnerEnforced, BucketOwnerPreferred, ObjectWriter."
  type        = string
  default     = "BucketOwnerEnforced"
  validation {
    condition     = contains(["BucketOwnerEnforced", "BucketOwnerPreferred", "ObjectWriter"], var.object_ownership)
    error_message = "object_ownership must be BucketOwnerEnforced, BucketOwnerPreferred, or ObjectWriter."
  }
}

variable "enforce_ssl" {
  description = "Whether to deny non-SSL (HTTP) transport requests to the bucket via a bucket policy"
  type        = bool
  default     = true
}

variable "enable_lifecycle_rules" {
  description = "Whether to enable default intelligent tiering / noncurrent version expiration lifecycle rules"
  type        = bool
  default     = false
}

variable "noncurrent_version_transition_days" {
  description = "Number of days before noncurrent object versions transition to STANDARD_IA"
  type        = number
  default     = 30
}

variable "noncurrent_version_expiration_days" {
  description = "Number of days before noncurrent object versions expire completely"
  type        = number
  default     = 90
}

variable "logging_target_bucket" {
  description = "Target bucket name for access logging. If null, logging is disabled."
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Target prefix for access logging"
  type        = string
  default     = "log/"
}

variable "tags" {
  description = "A mapping of tags to assign to the S3 bucket"
  type        = map(string)
  default     = {}
}
