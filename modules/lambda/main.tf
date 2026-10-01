locals {
  use_default_code = var.source_file == null && var.source_dir == null
}

data "archive_file" "default_payload" {
  count       = local.use_default_code ? 1 : 0
  type        = "zip"
  output_path = "${path.module}/default_payload.zip"

  source {
    content  = <<-EOF
      import json

      def handler(event, context):
          return {
              'statusCode': 200,
              'headers': {'Content-Type': 'application/json'},
              'body': json.dumps({'message': 'Hello from Terraform-managed AWS Lambda!'})
          }
    EOF
    filename = "index.py"
  }
}

data "archive_file" "custom_file" {
  count       = var.source_file != null ? 1 : 0
  type        = "zip"
  source_file = var.source_file
  output_path = "${path.module}/source_file.zip"
}

data "archive_file" "custom_dir" {
  count       = var.source_dir != null ? 1 : 0
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/source_dir.zip"
}

locals {
  archive_path = local.use_default_code ? data.archive_file.default_payload[0].output_path : (var.source_file != null ? data.archive_file.custom_file[0].output_path : data.archive_file.custom_dir[0].output_path)
  source_hash  = local.use_default_code ? data.archive_file.default_payload[0].output_base64sha256 : (var.source_file != null ? data.archive_file.custom_file[0].output_base64sha256 : data.archive_file.custom_dir[0].output_base64sha256)
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_in_days

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
    }
  )
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.function_name}-exec-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
    }
  )
}

resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "vpc_access" {
  count      = length(var.vpc_subnet_ids) > 0 ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_policy" "custom" {
  count  = var.custom_policy_json != null ? 1 : 0
  name   = "${var.function_name}-custom-policy"
  policy = var.custom_policy_json

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
    }
  )
}

resource "aws_iam_role_policy_attachment" "custom" {
  count      = var.custom_policy_json != null ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.custom[0].arn
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  description   = var.description
  role          = aws_iam_role.this.arn
  handler       = var.handler
  runtime       = var.runtime
  memory_size   = var.memory_size
  timeout       = var.timeout

  filename         = local.archive_path
  source_code_hash = local.source_hash

  kms_key_arn = var.kms_key_arn

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [1] : []
    content {
      variables = var.environment_variables
    }
  }

  dynamic "vpc_config" {
    for_each = length(var.vpc_subnet_ids) > 0 ? [1] : []
    content {
      subnet_ids         = var.vpc_subnet_ids
      security_group_ids = var.vpc_security_group_ids
    }
  }

  tracing_config {
    mode = var.tracing_mode
  }

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
    }
  )

  depends_on = [
    aws_cloudwatch_log_group.this,
    aws_iam_role_policy_attachment.basic_execution
  ]
}
