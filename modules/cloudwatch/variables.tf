variable "name" {
  description = "Name prefix for CloudWatch resources"
  type        = string
}

variable "create_log_group" {
  description = "Whether to create a CloudWatch Log Group"
  type        = bool
  default     = true
}

variable "log_group_name" {
  description = "Name of the log group. If null, '/aws/app/{name}' is used."
  type        = string
  default     = null
}

variable "log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events"
  type        = number
  default     = 30
}

variable "kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = null
}

variable "alarms" {
  description = "Map of CloudWatch metric alarms to configure"
  type = map(object({
    comparison_operator = string
    evaluation_periods  = number
    metric_name         = string
    namespace           = string
    period              = number
    statistic           = string
    threshold           = number
    alarm_description   = optional(string, "")
    dimensions          = optional(map(string), {})
  }))
  default = {}
}

variable "alarm_actions" {
  description = "The list of actions to execute when this alarm transitions into an ALARM state (e.g. SNS Topic ARN)"
  type        = list(string)
  default     = []
}

variable "ok_actions" {
  description = "The list of actions to execute when this alarm transitions into an OK state"
  type        = list(string)
  default     = []
}

variable "create_dashboard" {
  description = "Whether to provision an operational CloudWatch Dashboard"
  type        = bool
  default     = false
}

variable "dashboard_name" {
  description = "The name of the dashboard. If null, '{name}-operational-dashboard' is used."
  type        = string
  default     = null
}

variable "dashboard_body" {
  description = "The detailed JSON definition of the dashboard. If null, a standard operational overview dashboard is provisioned."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
