variable "name" {
  description = "The name of the Application Load Balancer and associated target group"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the ALB and Target Group will be deployed"
  type        = string
}

variable "subnets" {
  description = "A list of at least two subnet IDs across different Availability Zones"
  type        = list(string)
}

variable "internal" {
  description = "If true, the LB will be internal. If false, internet-facing."
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API"
  type        = bool
  default     = false
}

variable "drop_invalid_header_fields" {
  description = "Indicates whether HTTP headers with invalid header fields are removed by the load balancer"
  type        = bool
  default     = true
}

variable "create_security_group" {
  description = "Whether to create a dedicated security group for the ALB"
  type        = bool
  default     = true
}

variable "security_groups" {
  description = "A list of existing security group IDs to assign to the LB"
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "target_type" {
  description = "Type of target that you must specify when registering targets: instance, ip, or alb"
  type        = string
  default     = "instance"
}

variable "target_port" {
  description = "Port on which targets receive traffic"
  type        = number
  default     = 80
}

variable "target_protocol" {
  description = "Protocol to use for routing traffic to the targets (HTTP or HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Destination for the health check request"
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "The port the load balancer uses when performing health checks on targets"
  type        = string
  default     = "traffic-port"
}

variable "health_check_protocol" {
  description = "Protocol the load balancer uses when performing health checks on targets"
  type        = string
  default     = "HTTP"
}

variable "health_check_interval" {
  description = "Approximate amount of time, in seconds, between health checks of an individual target"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Amount of time, in seconds, during which no response means a failed health check"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Number of consecutive health check successes required before considering an unhealthy target healthy"
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "Number of consecutive health check failures required before considering a target unhealthy"
  type        = number
  default     = 3
}

variable "health_check_matcher" {
  description = "HTTP response codes to use when checking for a healthy responses from a target"
  type        = string
  default     = "200-399"
}

variable "enable_https" {
  description = "Whether to configure an HTTPS listener on port 443"
  type        = bool
  default     = false
}

variable "certificate_arn" {
  description = "The ARN of the default SSL server certificate. Required if enable_https is true."
  type        = string
  default     = null
}

variable "ssl_policy" {
  description = "Name of the SSL Policy for the HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "redirect_http_to_https" {
  description = "Whether to redirect HTTP (port 80) traffic to HTTPS (port 443)"
  type        = bool
  default     = false
}

variable "target_instance_ids" {
  description = "Optional list of EC2 instance IDs to attach to the target group"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
