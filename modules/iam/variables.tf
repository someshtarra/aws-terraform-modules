variable "role_name" {
  description = "Name of the IAM role to create"
  type        = string
}

variable "role_description" {
  description = "Description of the IAM role"
  type        = string
  default     = "IAM Role provisioned by Terraform"
}

variable "trusted_entity_services" {
  description = "List of AWS services allowed to assume the role (e.g. ['ec2.amazonaws.com', 'lambda.amazonaws.com'])"
  type        = list(string)
  default     = []
}

variable "trusted_entity_arns" {
  description = "List of IAM ARNs allowed to assume the role (e.g. for cross-account trust or OIDC providers)"
  type        = list(string)
  default     = []
}

variable "custom_assume_role_policy" {
  description = "Override raw JSON policy document for trust relationship if complex conditions are needed"
  type        = string
  default     = null
}

variable "custom_policy_name" {
  description = "Name of the custom customer-managed IAM policy (defaults to {role_name}-policy if null)"
  type        = string
  default     = null
}

variable "custom_policy_description" {
  description = "Description for the custom IAM policy"
  type        = string
  default     = "Custom IAM policy provisioned by Terraform"
}

variable "custom_policy_json" {
  description = "A valid IAM policy document in JSON format to create and attach to the role"
  type        = string
  default     = null
}

variable "managed_policy_arns" {
  description = "List of existing managed policy ARNs to attach to the role (e.g. ['arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore'])"
  type        = list(string)
  default     = []
}

variable "create_instance_profile" {
  description = "Whether to create an IAM instance profile for EC2 instances using this role"
  type        = bool
  default     = false
}

variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds (between 3600 and 43200)"
  type        = number
  default     = 3600
  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration must be between 3600 (1 hour) and 43200 (12 hours)."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to all IAM resources"
  type        = map(string)
  default     = {}
}
