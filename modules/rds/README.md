# AWS RDS Terraform Module

A production-grade, hardened Terraform module to provision Amazon Relational Database Service (RDS) instances supporting MySQL, PostgreSQL, and MariaDB engines with automated storage autoscaling, KMS encryption, automated backups, and restricted network security.

## Features

- **Multi-Engine Support**: Pre-configured defaults for MySQL, PostgreSQL, and MariaDB.
- **Enterprise Storage Configuration**: Defaults to performant `gp3` storage with dynamic storage autoscaling (`max_allocated_storage`).
- **Encrypted-at-Rest**: Enforces EBS storage encryption using AWS KMS Customer Managed Keys (CMK) or AWS managed keys.
- **Zero Public Exposure**: `publicly_accessible = false` by default, strictly isolating the database inside private/database subnets.
- **Dedicated Security Group**: Automatically generates a least-privilege security group accepting connections only from specified application security groups.
- **Automated Backups & Maintenance**: Configurable backup retention periods, backup windows, and maintenance schedules.
- **Custom Parameter Groups**: Optional creation of database parameter groups for fine-grained database engine optimization.

## Usage

```hcl
module "rds_mysql" {
  source = "../../modules/rds"

  name           = "app-production"
  engine         = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t4g.micro"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = true
  kms_key_id            = "arn:aws:kms:us-east-1:123456789012:key/abcd-1234-efgh"

  db_name  = "proddb"
  username = "adminuser"
  password = var.db_password # Injected securely via variable or secrets manager

  vpc_id               = "vpc-0123456789abcdef0"
  db_subnet_group_name = "production-app-db-subnet-group"

  # Allow incoming traffic only from Web EC2 security group
  allowed_security_group_ids = ["sg-0123456789abcdef0"]

  multi_az            = true
  deletion_protection = true

  tags = {
    Environment = "production"
    Tier        = "database"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | Allocated storage in GB | `number` | `20` | no |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | Allowed CIDR blocks for DB connection | `list(string)` | `[]` | no |
| <a name="input_allowed_security_group_ids"></a> [allowed\_security\_group\_ids](#input\_allowed\_security\_group\_ids) | Security group IDs permitted to connect | `list(string)` | `[]` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Auto apply minor version updates | `bool` | `true` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Days to retain automated backups | `number` | `7` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Name of database to create | `string` | `"appdb"` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | Existing DB subnet group name | `string` | `null` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Prevent accidental DB deletion | `bool` | `false` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | Engine (`mysql`, `postgres`, `mariadb`) | `string` | `"mysql"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Database engine version | `string` | `"8.0"` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | DB instance class | `string` | `"db.t4g.micro"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ARN for storage encryption | `string` | `null` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | Autoscaling storage ceiling (GB) | `number` | `100` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Deploy Multi-AZ standby | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name identifier prefix | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Master DB password | `string` | n/a | yes |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Allow public internet connections | `bool` | `false` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Enable EBS encryption | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs for new subnet group | `list(string)` | `[]` | no |
| <a name="input_username"></a> [username](#input\_username) | Master DB username | `string` | `"dbadmin"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID for database security group | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_instance_address"></a> [db\_instance\_address](#output\_db\_instance\_address) | Hostname / address of database |
| <a name="output_db_instance_arn"></a> [db\_instance\_arn](#output\_db\_instance\_arn) | ARN of RDS instance |
| <a name="output_db_instance_endpoint"></a> [db\_instance\_endpoint](#output\_db\_instance\_endpoint) | Full endpoint connection string |
| <a name="output_db_instance_id"></a> [db\_instance\_id](#output\_db\_instance\_id) | Identifier of RDS instance |
| <a name="output_db_instance_port"></a> [db\_instance\_port](#output\_db\_instance\_port) | Database port |
| <a name="output_db_security_group_id"></a> [db\_security\_group\_id](#output\_db\_security\_group\_id) | ID of security group created for RDS |
