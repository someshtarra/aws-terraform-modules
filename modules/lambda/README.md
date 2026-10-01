# AWS Lambda Terraform Module

A production-grade Terraform module to package, deploy, and manage AWS Lambda serverless functions, execution IAM roles, CloudWatch Log Groups with retention, VPC integration, AWS X-Ray tracing, and KMS encryption.

## Features

- **Automated Packaging**: Bundles single files, directories, or a built-in fallback starter template using the Terraform `archive_file` provider.
- **Dedicated CloudWatch Log Group**: Automatically provisions `/aws/lambda/<function_name>` with configurable log retention days to prevent unbounded CloudWatch storage bills.
- **Least-Privilege Execution Role**: Provisions IAM role with `AWSLambdaBasicExecutionRole` and optional `AWSLambdaVPCAccessExecutionRole`.
- **VPC Subnet & Security Group Binding**: Seamlessly run Lambda functions within private VPC subnets to query RDS, Redis, or internal services.
- **Active X-Ray Tracing**: Enabled by default (`Active`) for distributed serverless observability.
- **Environment Variable Encryption**: Supports AWS KMS Customer Managed Keys for securing secrets.

## Usage

```hcl
module "process_order_lambda" {
  source = "../../modules/lambda"

  function_name = "process-order"
  description   = "Processes customer orders and updates database"
  handler       = "index.handler"
  runtime       = "python3.11"
  memory_size   = 256
  timeout       = 30

  environment_variables = {
    ENVIRONMENT = "production"
    LOG_LEVEL   = "INFO"
  }

  log_retention_in_days = 30
  tracing_mode          = "Active"

  tags = {
    Environment = "production"
    Service     = "order-processing"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >= 2.4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_policy_json"></a> [custom\_policy\_json](#input\_custom\_policy\_json) | Custom IAM policy JSON for Lambda | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of function | `string` | `"..."` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Map of environment variables | `map(string)` | `{}` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of Lambda function | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | Function entrypoint | `string` | `"index.handler"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS Key ARN for env encryption | `string` | `null` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Memory size in MB | `number` | `128` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Runtime identifier | `string` | `"python3.11"` | no |
| <a name="input_source_dir"></a> [source\_dir](#input\_source\_dir) | Directory of source code | `string` | `null` | no |
| <a name="input_source_file"></a> [source\_file](#input\_source\_file) | Single source code file | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Timeout in seconds | `number` | `30` | no |
| <a name="input_tracing_mode"></a> [tracing\_mode](#input\_tracing\_mode) | Tracing mode (PassThrough or Active) | `string` | `"Active"` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | Security group IDs for VPC | `list(string)` | `[]` | no |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | Subnet IDs for VPC | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | ARN of Lambda function |
| <a name="output_function_invoke_arn"></a> [function\_invoke\_arn](#output\_function\_invoke\_arn) | Invoke ARN for API Gateway |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | Name of Lambda function |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | ARN of CloudWatch log group |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of IAM execution role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Name of IAM execution role |
