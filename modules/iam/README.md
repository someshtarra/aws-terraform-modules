# AWS IAM Terraform Module

A robust Terraform module to provision AWS Identity and Access Management (IAM) Roles, Custom Policies, Managed Policy Attachments, and EC2 Instance Profiles following least-privilege security principles.

## Features

- **Flexible Assume Role**: Allows trust relationships with AWS services (EC2, Lambda, ECS, etc.) or cross-account IAM ARNs.
- **Custom Policy Generation**: Supports inline creation of custom IAM JSON policies with automated role binding.
- **AWS Managed Policy Attachment**: Accepts a set of managed policy ARNs (e.g., `AmazonSSMManagedInstanceCore`).
- **EC2 Instance Profile**: Optional creation of IAM instance profiles for EC2 workloads.
- **Configurable Session Duration**: Supports setting max session duration up to 12 hours.

## Usage

```hcl
module "ec2_iam_role" {
  source = "../../modules/iam"

  role_name               = "web-server-ec2-role"
  role_description        = "Role for EC2 web servers with SSM and S3 read permissions"
  trusted_entity_services = ["ec2.amazonaws.com"]
  create_instance_profile = true

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  custom_policy_name = "web-server-s3-read"
  custom_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowS3ReadOnly"
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Resource = ["arn:aws:s3:::my-secure-bucket", "arn:aws:s3:::my-secure-bucket/*"]
      }
    ]
  })

  tags = {
    Environment = "production"
    Tier        = "compute"
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
| <a name="input_create_instance_profile"></a> [create\_instance\_profile](#input\_create\_instance\_profile) | Whether to create an IAM instance profile | `bool` | `false` | no |
| <a name="input_custom_assume_role_policy"></a> [custom\_assume\_role\_policy](#input\_custom\_assume\_role\_policy) | Override trust policy JSON | `string` | `null` | no |
| <a name="input_custom_policy_description"></a> [custom\_policy\_description](#input\_custom\_policy\_description) | Description of custom policy | `string` | `"Custom IAM policy provisioned by Terraform"` | no |
| <a name="input_custom_policy_json"></a> [custom\_policy\_json](#input\_custom\_policy\_json) | JSON policy document to attach | `string` | `null` | no |
| <a name="input_custom_policy_name"></a> [custom\_policy\_name](#input\_custom\_policy\_name) | Name of custom policy | `string` | `null` | no |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | List of managed policy ARNs | `list(string)` | `[]` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Session duration in seconds | `number` | `3600` | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | Description of the IAM role | `string` | `"IAM Role provisioned by Terraform"` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the IAM role | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags | `map(string)` | `{}` | no |
| <a name="input_trusted_entity_arns"></a> [trusted\_entity\_arns](#input\_trusted\_entity\_arns) | List of IAM ARNs allowed to assume role | `list(string)` | `[]` | no |
| <a name="input_trusted_entity_services"></a> [trusted\_entity\_services](#input\_trusted\_entity\_services) | List of AWS services allowed to assume role | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_policy_arn"></a> [custom\_policy\_arn](#output\_custom\_policy\_arn) | ARN of custom IAM policy |
| <a name="output_instance_profile_arn"></a> [instance\_profile\_arn](#output\_instance\_profile\_arn) | ARN of IAM instance profile |
| <a name="output_instance_profile_name"></a> [instance\_profile\_name](#output\_instance\_profile\_name) | Name of IAM instance profile |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the IAM role |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | Unique ID of the IAM role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Name of the IAM role |
