variable "name" {
  description = "Name identifier prefix for RDS database resources"
  type        = string
}

variable "engine" {
  description = "The database engine to use (mysql, postgres, etc.)"
  type        = string
  default     = "mysql"
  validation {
    condition     = contains(["mysql", "postgres", "mariadb"], var.engine)
    error_message = "Supported engine values are mysql, postgres, or mariadb."
  }
}

variable "engine_version" {
  description = "The engine version to use (e.g. '8.0' for mysql or '15.4' for postgres)"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "The instance type of the RDS instance (e.g. db.t4g.micro, db.t4g.small, db.r6g.large)"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "The upper limit to which Amazon RDS can automatically scale storage (GB). Set to 0 to disable storage autoscaling."
  type        = number
  default     = 100
}

variable "storage_type" {
  description = "One of 'standard', 'gp2', 'gp3', or 'io1'"
  type        = string
  default     = "gp3"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. If not specified, the default AWS KMS key for RDS will be used."
  type        = string
  default     = null
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
  default     = "appdb"
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
  default     = "dbadmin"
}

variable "password" {
  description = "Password for the master DB user. Note: should be managed securely via secrets/variables."
  type        = string
  sensitive   = true
}

variable "port" {
  description = "The port on which the DB accepts connections. If null, default is derived from engine (3306 for mysql, 5432 for postgres)."
  type        = number
  default     = null
}

variable "vpc_id" {
  description = "The VPC ID where the RDS security group will be created"
  type        = string
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs. Used if db_subnet_group_name is not provided."
  type        = list(string)
  default     = []
}

variable "db_subnet_group_name" {
  description = "Name of DB subnet group. If not provided, one will be created from subnet_ids."
  type        = string
  default     = null
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible. Defaults to false for security."
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "The days to retain backups for. Must be between 0 and 35."
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "The window to perform maintenance in"
  type        = string
  default     = "Mon:04:00-Mon:05:00"
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = true
}

variable "final_snapshot_identifier" {
  description = "The name which is given to the final snapshot on destruction"
  type        = string
  default     = null
}

variable "allowed_security_group_ids" {
  description = "List of security group IDs permitted to connect to the database"
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks permitted to connect to the database"
  type        = list(string)
  default     = []
}

variable "parameter_group_family" {
  description = "The family of the DB parameter group (e.g. mysql8.0 or postgres15). If null, default AWS parameter group is used."
  type        = string
  default     = null
}

variable "parameters" {
  description = "A list of DB parameter maps to apply"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
