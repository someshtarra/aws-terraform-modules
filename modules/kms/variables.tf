variable "description" {
  description = "The description of the KMS key as viewed in AWS console"
  type        = string
  default     = "Customer Managed Key (CMK) managed by Terraform"
}

variable "key_usage" {
  description = "Specifies the intended use of the key. Valid values: ENCRYPT_DECRYPT or SIGN_VERIFY"
  type        = string
  default     = "ENCRYPT_DECRYPT"
  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "SIGN_VERIFY"], var.key_usage)
    error_message = "key_usage must be either ENCRYPT_DECRYPT or SIGN_VERIFY."
  }
}

variable "customer_master_key_spec" {
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, ECC_NIST_P256, etc."
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}

variable "deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource (between 7 and 30)"
  type        = number
  default     = 30
  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "deletion_window_in_days must be between 7 and 30 days."
  }
}

variable "is_enabled" {
  description = "Specifies whether the key is enabled"
  type        = bool
  default     = true
}

variable "enable_key_rotation" {
  description = "Specifies whether key rotation is enabled. Defaults to true for compliance."
  type        = bool
  default     = true
}

variable "alias_name" {
  description = "The display name for the alias. Do not include 'alias/' prefix, it will be added automatically."
  type        = string
  default     = null
}

variable "policy" {
  description = "A valid policy JSON document. Although optional, if not specified, AWS applies a default key policy that grants administrative permissions to the root user."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the KMS key and alias"
  type        = map(string)
  default     = {}
}
