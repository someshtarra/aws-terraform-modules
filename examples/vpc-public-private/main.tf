data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc_flow_logs_group" {
  source = "../../modules/cloudwatch"

  name                  = "${var.vpc_name}-flow-logs"
  log_retention_in_days = 14
}

data "aws_iam_policy_document" "flow_log_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "flow_log" {
  name               = "${var.vpc_name}-flow-log-role"
  assume_role_policy = data.aws_iam_policy_document.flow_log_role.json
}

resource "aws_iam_role_policy" "flow_log" {
  name = "${var.vpc_name}-flow-log-policy"
  role = aws_iam_role.flow_log.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

module "vpc" {
  source = "../../modules/vpc"

  name       = var.vpc_name
  cidr_block = var.vpc_cidr

  azs              = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_flow_log           = true
  flow_log_destination_type = "cloud-watch-logs"
  flow_log_destination_arn  = module.vpc_flow_logs_group.log_group_arn
  flow_log_iam_role_arn     = aws_iam_role.flow_log.arn

  tags = {
    Environment = "production"
    NetworkTier = "hub-spoke"
  }
}
