locals {
  default_port = var.engine == "postgres" ? 5432 : 3306
  db_port      = var.port != null ? var.port : local.default_port
}

resource "aws_db_subnet_group" "this" {
  count       = var.db_subnet_group_name == null && length(var.subnet_ids) > 0 ? 1 : 0
  name        = "${var.name}-db-subnet-group"
  description = "Database subnet group for ${var.name}"
  subnet_ids  = var.subnet_ids

  tags = merge(
    var.tags,
    {
      Name      = "${var.name}-db-subnet-group"
      ManagedBy = "Terraform"
    }
  )
}

locals {
  subnet_group_name = var.db_subnet_group_name != null ? var.db_subnet_group_name : aws_db_subnet_group.this[0].name
}

resource "aws_security_group" "this" {
  name        = "${var.name}-rds-sg"
  description = "Control database ingress traffic for ${var.name}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = length(var.allowed_security_group_ids) > 0 ? [1] : []
    content {
      description     = "Database access from trusted security groups"
      from_port       = local.db_port
      to_port         = local.db_port
      protocol        = "tcp"
      security_groups = var.allowed_security_group_ids
    }
  }

  dynamic "ingress" {
    for_each = length(var.allowed_cidr_blocks) > 0 ? [1] : []
    content {
      description = "Database access from trusted CIDRs"
      from_port   = local.db_port
      to_port     = local.db_port
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidr_blocks
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name      = "${var.name}-rds-sg"
      ManagedBy = "Terraform"
    }
  )
}

resource "aws_db_parameter_group" "this" {
  count       = var.parameter_group_family != null ? 1 : 0
  name        = "${var.name}-pg"
  family      = var.parameter_group_family
  description = "Custom parameter group for ${var.name}"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
    }
  )
}

resource "aws_db_instance" "this" {
  identifier = "${var.name}-db"

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = var.kms_key_id

  db_name  = var.db_name
  username = var.username
  password = var.password
  port     = local.db_port

  vpc_security_group_ids = [aws_security_group.this.id]
  db_subnet_group_name   = local.subnet_group_name
  parameter_group_name   = var.parameter_group_family != null ? aws_db_parameter_group.this[0].name : null

  multi_az            = var.multi_az
  publicly_accessible = var.publicly_accessible

  backup_retention_period    = var.backup_retention_period
  backup_window              = var.backup_window
  maintenance_window         = var.maintenance_window
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier

  tags = merge(
    var.tags,
    {
      Name      = "${var.name}-db"
      ManagedBy = "Terraform"
    }
  )
}
