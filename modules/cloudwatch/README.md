# AWS CloudWatch Terraform Module

A production-grade Terraform module to provision AWS CloudWatch Log Groups with retention and KMS encryption, Metric Alarms (CPU, 5XX errors, latency), and CloudWatch Operational Dashboards.

## Features

- **Automated Retention Management**: Enforces log expiration (e.g. 14, 30, or 90 days) to prevent runaway CloudWatch ingestion and storage charges.
- **KMS Encrypted Logs**: Optional integration with Customer Managed Keys for regulatory log privacy and compliance.
- **Flexible Dynamic Alarms**: Easily configure multiple metric alarms using an HCL map structure (e.g. High CPU, ALB 5XXs, Memory).
- **Incident Response Integration**: Dispatches alerts directly to SNS topics for PagerDuty, Slack, or email notifications.
- **Unified Operational Dashboards**: Automated multi-widget metric dashboard creation.

## Usage

```hcl
module "cloudwatch" {
  source = "../../modules/cloudwatch"

  name                  = "ecommerce-prod"
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
        InstanceId = "i-0123456789abcdef0"
      }
    }
  }

  alarm_actions = ["arn:aws:sns:us-east-1:123456789012:ops-alerts-topic"]

  tags = {
    Environment = "production"
    Tier        = "observability"
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
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | SNS ARNs for alarm transition | `list(string)` | `[]` | no |
| <a name="input_alarms"></a> [alarms](#input\_alarms) | Map of CloudWatch metric alarms | `map(object)` | `{}` | no |
| <a name="input_create_dashboard"></a> [create\_dashboard](#input\_create\_dashboard) | Provision operational dashboard | `bool` | `false` | no |
| <a name="input_create_log_group"></a> [create\_log\_group](#input\_create\_log\_group) | Provision log group | `bool` | `true` | no |
| <a name="input_dashboard_body"></a> [dashboard\_body](#input\_dashboard\_body) | Custom JSON dashboard body | `string` | `null` | no |
| <a name="input_dashboard_name"></a> [dashboard\_name](#input\_dashboard\_name) | Custom dashboard name | `string` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ARN for log group | `string` | `null` | no |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | Custom log group name | `string` | `null` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Log retention in days | `number` | `30` | no |
| <a name="input_name"></a> [name](#input\_name) | Name prefix for resources | `string` | n/a | yes |
| <a name="input_ok_actions"></a> [ok\_actions](#input\_ok\_actions) | SNS ARNs for OK transition | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_arns"></a> [alarm\_arns](#output\_alarm\_arns) | Map of alarm keys to ARNs |
| <a name="output_alarm_names"></a> [alarm\_names](#output\_alarm\_names) | Map of alarm keys to names |
| <a name="output_dashboard_arn"></a> [dashboard\_arn](#output\_dashboard\_arn) | ARN of CloudWatch dashboard |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | ARN of CloudWatch log group |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | Name of CloudWatch log group |
