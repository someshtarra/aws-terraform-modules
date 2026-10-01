data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "../../modules/vpc"

  name       = "rds-demo-vpc"
  cidr_block = "10.10.0.0/16"
  azs        = slice(data.aws_availability_zones.available.names, 0, 2)

  # Only database subnets for isolated database demo
  database_subnets   = ["10.10.21.0/24", "10.10.22.0/24"]
  enable_nat_gateway = false
}

module "kms" {
  source = "../../modules/kms"

  description             = "KMS Key for RDS MySQL Demo"
  alias_name              = "rds-mysql-demo-key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

module "rds_mysql" {
  source = "../../modules/rds"

  name           = "demo-mysql"
  engine         = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t4g.micro"

  allocated_storage     = 20
  max_allocated_storage = 50
  storage_encrypted     = true
  kms_key_id            = module.kms.key_arn

  db_name  = "demodb"
  username = "adminuser"
  password = var.db_password

  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.database_subnet_group_name

  # Allow VPC internal CIDR for demo
  allowed_cidr_blocks = [module.vpc.vpc_cidr_block]

  multi_az            = false
  deletion_protection = false
  skip_final_snapshot = true

  tags = {
    Role = "relational-database"
  }
}
