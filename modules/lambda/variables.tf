variable "function_name" {
  description = "A unique name for your Lambda Function"
  type        = string
}

variable "description" {
  description = "Description of what your Lambda Function does"
  type        = string
  default     = "Lambda function provisioned by Terraform"
}

variable "handler" {
  description = "Function entrypoint in your code"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Identifier of the function's runtime (e.g. python3.11, nodejs20.x)"
  type        = string
  default     = "python3.11"
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Amount of time your Lambda Function has to run in seconds"
  type        = number
  default     = 30
}

variable "source_file" {
  description = "Path to single source code file (mutually exclusive with source_dir)"
  type        = string
  default     = null
}

variable "source_dir" {
  description = "Path to directory containing source code"
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "A map that defines environment variables available to the Lambda Function"
  type        = map(string)
  default     = {}
}

variable "vpc_subnet_ids" {
  description = "List of subnet IDs associated with the Lambda function (if running inside VPC)"
  type        = list(string)
  default     = []
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs associated with the Lambda function (if running inside VPC)"
  type        = list(string)
  default     = []
}

variable "kms_key_arn" {
  description = "Amazon Resource Name (ARN) of the KMS key used to encrypt your function's environment variables"
  type        = string
  default     = null
}

variable "log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  type        = number
  default     = 14
}

variable "tracing_mode" {
  description = "Tracing mode of the function (PassThrough or Active)"
  type        = string
  default     = "Active"
}

variable "custom_policy_json" {
  description = "An additional custom IAM policy document in JSON format to attach to the Lambda role"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
