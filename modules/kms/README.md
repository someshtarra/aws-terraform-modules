# AWS KMS Terraform Module

A production-grade Terraform module to provision and manage AWS Key Management Service (KMS) Customer Managed Keys (CMK) with automatic key rotation, least-privilege key policies, and aliases.

## Features

- **Automated Key Rotation**: Enforces annual automatic key rotation compliant with CIS AWS Foundations Benchmark.
- **Configurable Key Spec**: Supports symmetric encryption (`SYMMETRIC_DEFAULT`) and asymmetric signing/encryption specs.
- **Configurable Deletion Window**: Protects against accidental destruction with a safe waiting period (7 to 30 days).
- **Alias Management**: Provisions user-friendly alias pointers (e.g., `alias/app-storage-key`).
- **Secure Default Key Policy**: Automatically provisions an administrative root policy if a custom policy is not provided.

## Usage

```hcl
module "kms" {
  source = "../../modules/kms"

  description             = "KMS Key for RDS and S3 data encryption"
  alias_name              = "prod-app-encryption-key"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Environment = "production"
    Application = "payment-gateway"
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
| <a name="input_alias_name"></a> [alias\_name](#input\_alias\_name) | Display name for the key alias (without `alias/` prefix) | `string` | `null` | no |
| <a name="input_customer_master_key_spec"></a> [customer\_master\_key\_spec](#input\_customer\_master\_key\_spec) | Key spec for symmetric or asymmetric algorithms | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | Waiting period in days before key deletion (7-30) | `number` | `30` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the KMS key | `string` | `"Customer Managed Key (CMK) managed by Terraform"` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | Whether automatic key rotation is enabled | `bool` | `true` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Whether the key is enabled | `bool` | `true` | no |
| <a name="input_key_usage"></a> [key\_usage](#input\_key\_usage) | Intended key usage (`ENCRYPT_DECRYPT` or `SIGN_VERIFY`) | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | Custom IAM Key Policy JSON document | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alias_arn"></a> [alias\_arn](#output\_alias\_arn) | ARN of the key alias |
| <a name="output_alias_name"></a> [alias\_name](#output\_alias\_name) | Display name of the alias |
| <a name="output_key_arn"></a> [key\_arn](#output\_key\_arn) | ARN of the KMS key |
| <a name="output_key_id"></a> [key\_id](#output\_key\_id) | Unique ID of the KMS key |
