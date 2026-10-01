data "aws_availability_zones" "available" {
  state = "available"
}

################################################################################
# 1. KMS Customer Managed Key (CMK) for Encryption at Rest
################################################################################

module "kms" {
  source = "../../modules/kms"

  description             = "CMK for ${var.project_name}-${var.environment} infrastructure"
  alias_name              = "${var.project_name}-${var.environment}-cmk"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

################################################################################
# 2. Multi-AZ Network Topology (VPC)
################################################################################

module "vpc" {
  source = "../../modules/vpc"

  name       = "${var.project_name}-${var.environment}"
  cidr_block = var.vpc_cidr

  azs              = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.10.0/24", "10.0.20.0/24"]
  database_subnets = ["10.0.30.0/24", "10.0.40.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true # Can be set to false for multi-AZ NAT high-availability
}

################################################################################
# 3. Secure S3 Storage Bucket
################################################################################

module "s3_assets" {
  source = "../../modules/s3"

  bucket_prefix      = "${var.project_name}-${var.environment}-assets-"
  versioning_status  = "Enabled"
  kms_master_key_id  = module.kms.key_arn
  bucket_key_enabled = true
  enforce_ssl        = true

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  enable_lifecycle_rules             = true
  noncurrent_version_transition_days = 30
  noncurrent_version_expiration_days = 90
}

################################################################################
# 4. IAM Role & Instance Profile for EC2
################################################################################

module "ec2_iam" {
  source = "../../modules/iam"

  role_name               = "${var.project_name}-${var.environment}-ec2-role"
  role_description        = "IAM role for web app EC2 instances"
  trusted_entity_services = ["ec2.amazonaws.com"]
  create_instance_profile = true

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  custom_policy_name = "${var.project_name}-${var.environment}-s3-access"
  custom_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3ObjectAccess"
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:ListBucket"]
        Resource = [
          module.s3_assets.bucket_arn,
          "${module.s3_assets.bucket_arn}/*"
        ]
      },
      {
        Sid      = "AllowKMSDecrypt"
        Effect   = "Allow"
        Action   = ["kms:Decrypt", "kms:GenerateDataKey"]
        Resource = [module.kms.key_arn]
      }
    ]
  })
}

################################################################################
# 5. Application Load Balancer (Public Ingress)
################################################################################

module "alb" {
  source = "../../modules/alb"

  name    = "${var.project_name}-${var.environment}"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnet_ids

  target_port       = 80
  target_protocol   = "HTTP"
  health_check_path = "/"

  drop_invalid_header_fields = true
}

################################################################################
# 6. EC2 Application Compute (Private Subnet)
################################################################################

module "ec2_app" {
  source = "../../modules/ec2"

  name          = "${var.project_name}-${var.environment}-web"
  instance_type = var.instance_type
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.private_subnet_ids[0]

  associate_public_ip_address = false
  iam_instance_profile        = module.ec2_iam.instance_profile_name

  root_volume_size = 30
  root_volume_type = "gp3"
  root_kms_key_id  = module.kms.key_arn

  create_security_group = true
  security_group_ingress_rules = [
    {
      description     = "Allow HTTP traffic from ALB security group"
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      security_groups = [module.alb.security_group_id]
    }
  ]

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nginx
              systemctl enable --now nginx
              echo "<h1>Enterprise App Server (${var.environment})</h1>" > /usr/share/nginx/html/index.html
              EOF
}

# Attach EC2 instance to ALB Target Group
resource "aws_lb_target_group_attachment" "app_attachment" {
  target_group_arn = module.alb.target_group_arn
  target_id        = module.ec2_app.instance_id
  port             = 80
}

################################################################################
# 7. Isolated Multi-AZ Relational Database (RDS MySQL)
################################################################################

module "rds" {
  source = "../../modules/rds"

  name           = "${var.project_name}-${var.environment}"
  engine         = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t4g.micro"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = true
  kms_key_id            = module.kms.key_arn

  db_name  = "enterprise_db"
  username = "masteradmin"
  password = var.db_password

  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.database_subnet_group_name

  # Strictly allow connection only from the EC2 application security group
  allowed_security_group_ids = [module.ec2_app.security_group_id]

  multi_az            = false # Set to true for HA Multi-AZ standby in production
  deletion_protection = false
  skip_final_snapshot = true
}

################################################################################
# 8. CloudWatch Observability & Alarms
################################################################################

module "cloudwatch" {
  source = "../../modules/cloudwatch"

  name                  = "${var.project_name}-${var.environment}"
  log_retention_in_days = 30
  create_dashboard      = true

  alarms = {
    high_cpu = {
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 2
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = 300
      statistic           = "Average"
      threshold           = 80
      alarm_description   = "Triggers when EC2 instance CPU exceeds 80% for 10 minutes"
      dimensions = {
        InstanceId = module.ec2_app.instance_id
      }
    }
  }
}
