data "aws_iam_policy_document" "assume_role" {
  count = var.custom_assume_role_policy == null ? 1 : 0

  dynamic "statement" {
    for_each = length(var.trusted_entity_services) > 0 ? [1] : []
    content {
      sid     = "AllowServicePrincipalAssume"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "Service"
        identifiers = var.trusted_entity_services
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.trusted_entity_arns) > 0 ? [1] : []
    content {
      sid     = "AllowArnPrincipalAssume"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "AWS"
        identifiers = var.trusted_entity_arns
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = var.role_name
  description          = var.role_description
  assume_role_policy   = var.custom_assume_role_policy != null ? var.custom_assume_role_policy : data.aws_iam_policy_document.assume_role[0].json
  max_session_duration = var.max_session_duration

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
    }
  )
}

resource "aws_iam_policy" "custom" {
  count       = var.custom_policy_json != null ? 1 : 0
  name        = var.custom_policy_name != null ? var.custom_policy_name : "${var.role_name}-policy"
  description = var.custom_policy_description
  policy      = var.custom_policy_json

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

resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = toset(var.managed_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0
  name  = "${var.role_name}-instance-profile"
  role  = aws_iam_role.this.name

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
    }
  )
}
