variable "name" {
  description = "Name prefix to be used on all VPC resources as identifier"
  type        = string
}

variable "cidr_block" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "A list of availability zones names in the region"
  type        = list(string)
}

variable "public_subnets" {
  description = "A list of public subnet CIDR blocks inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnet CIDR blocks inside the VPC"
  type        = list(string)
  default     = []
}

variable "database_subnets" {
  description = "A list of isolated database subnet CIDR blocks inside the VPC"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Should be true if you want only one NAT Gateway for all private subnets to save cost"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IPs on launch in public subnets"
  type        = bool
  default     = true
}

variable "enable_flow_log" {
  description = "Whether to enable VPC Flow Logs"
  type        = bool
  default     = false
}

variable "flow_log_destination_type" {
  description = "Type of flow log destination. Valid values: cloud-watch-logs, s3"
  type        = string
  default     = "cloud-watch-logs"
}

variable "flow_log_destination_arn" {
  description = "ARN of CloudWatch Log Group or S3 bucket to send flow logs to"
  type        = string
  default     = null
}

variable "flow_log_iam_role_arn" {
  description = "ARN for the IAM role that can publish flow logs to CloudWatch Logs"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
