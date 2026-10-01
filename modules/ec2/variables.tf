variable "name" {
  description = "Name to be used on EC2 instance and related resources"
  type        = string
}

variable "ami_id" {
  description = "ID of AMI to use for the instance. If omitted, latest Amazon Linux 2023 AMI is used automatically."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "The type of instance to start (e.g. t3.micro, t3.small, m6i.large)"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the security group should be created (required if create_security_group is true)"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC. Defaults to false for private security."
  type        = bool
  default     = false
}

variable "iam_instance_profile" {
  description = "The IAM Instance Profile to launch the instance with"
  type        = string
  default     = null
}

variable "user_data" {
  description = "The user-data script to provide when launching the instance"
  type        = string
  default     = null
}

variable "key_name" {
  description = "The existing key name of the Key Pair to use for the instance"
  type        = string
  default     = null
}

variable "public_key" {
  description = "The public key material to create a new AWS Key Pair. If provided, key_name is set to this key."
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in gigabytes"
  type        = number
  default     = 30
}

variable "root_volume_type" {
  description = "Type of root EBS volume. Standard: gp3"
  type        = string
  default     = "gp3"
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt the root block device"
  type        = bool
  default     = true
}

variable "root_kms_key_id" {
  description = "KMS key ARN used to encrypt the root block device"
  type        = string
  default     = null
}

variable "enable_additional_ebs_volume" {
  description = "Whether to provision and attach an additional EBS data volume"
  type        = bool
  default     = false
}

variable "additional_ebs_volume_size" {
  description = "Size of the additional EBS data volume in gigabytes"
  type        = number
  default     = 50
}

variable "additional_ebs_volume_type" {
  description = "Type of the additional EBS volume"
  type        = string
  default     = "gp3"
}

variable "additional_ebs_kms_key_id" {
  description = "KMS key ARN for the additional EBS volume"
  type        = string
  default     = null
}

variable "additional_ebs_device_name" {
  description = "Device name to expose to the instance (e.g. /dev/xvdf)"
  type        = string
  default     = "/dev/xvdf"
}

variable "create_security_group" {
  description = "Whether to create a dedicated security group for the instance"
  type        = bool
  default     = true
}

variable "security_group_ingress_rules" {
  description = "List of ingress rules for the created security group"
  type = list(object({
    description     = optional(string, "")
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string), [])
    security_groups = optional(list(string), [])
  }))
  default = []
}

variable "security_group_egress_rules" {
  description = "List of egress rules for the created security group"
  type = list(object({
    description     = optional(string, "Allow all outbound")
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string), ["0.0.0.0/0"])
    security_groups = optional(list(string), [])
  }))
  default = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "existing_security_group_ids" {
  description = "List of existing security group IDs to attach to the instance"
  type        = list(string)
  default     = []
}

variable "enable_detailed_monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = false
}

variable "enable_imds_v2" {
  description = "Enforce IMDSv2 (metadata service tokens required) for SSRF protection"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
