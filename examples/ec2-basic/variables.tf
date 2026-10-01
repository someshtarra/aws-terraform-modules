variable "aws_region" {
  description = "AWS Region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "basic-demo-server"
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t3.micro"
}

variable "vpc_id" {
  description = "VPC ID where the EC2 instance and security group will be provisioned. If omitted, default VPC is resolved."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet ID where the instance will launch. If omitted, default subnet is resolved."
  type        = string
  default     = null
}
