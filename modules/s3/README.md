# AWS S3 Terraform Module

A production-grade, hardened Terraform module to provision AWS Simple Storage Service (S3) buckets adhering strictly to CIS benchmarks and AWS Well-Architected Security Pillars.

## Features

- **Zero Public Exposure**: Public Access Block enabled across all 4 parameters (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`).
- **Enforced Encryption-in-Transit**: Automatically attaches a bucket policy denying any non-TLS/HTTPS request (`aws:SecureTransport = false`).
- **Encryption-at-Rest**: Configurable default SSE-AES256 or SSE-KMS with S3 Bucket Keys enabled (lowering KMS API request cost by up to 99%).
- **Object Versioning**: Enabled by default to protect against accidental deletions and ransomware.
- **Modern Ownership Controls**: Defaults to `BucketOwnerEnforced` (disables legacy ACLs).
- **Lifecycle Management**: Optional automated transitions to `STANDARD_IA` and expiration of non-current versions.
- **Server Access Logging**: Optional integration to forward access logs to an auditing bucket.

## Usage

```hcl
module "secure_bucket" {
  source = "../../modules/s3"

  bucket_name        = "my-enterprise-audit-logs-2026"
  versioning_status  = "Enabled"
  kms_master_key_id  = "arn:aws:kms:us-east-1:123456789012:key/abcd-1234-efgh"
  bucket_key_enabled = true
  enforce_ssl        = true

  enable_lifecycle_rules             = true
  noncurrent_version_transition_days = 30
  noncurrent_version_expiration_days = 90

  tags = {
    Environment = "production"
    Compliance  = "SOC2"
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
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Block public ACLs | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Block public bucket policies | `bool` | `true` | no |
| <a name="input_bucket_key_enabled"></a> [bucket\_key\_enabled](#input\_bucket\_key\_enabled) | Enable S3 Bucket Key for KMS cost reduction | `bool` | `true` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the S3 bucket | `string` | `null` | no |
| <a name="input_bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | Bucket name prefix | `string` | `null` | no |
| <a name="input_enable_lifecycle_rules"></a> [enable\_lifecycle\_rules](#input\_enable\_lifecycle\_rules) | Enable noncurrent version lifecycle management | `bool` | `false` | no |
| <a name="input_enforce_ssl"></a> [enforce\_ssl](#input\_enforce\_ssl) | Deny non-HTTPS requests via bucket policy | `bool` | `true` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Force delete non-empty bucket upon destruction | `bool` | `false` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Ignore public ACLs | `bool` | `true` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | KMS key ARN/ID for SSE-KMS (uses AES256 if null) | `string` | `null` | no |
| <a name="input_logging_target_bucket"></a> [logging\_target\_bucket](#input\_logging\_target\_bucket) | Target bucket for server access logs | `string` | `null` | no |
| <a name="input_logging_target_prefix"></a> [logging\_target\_prefix](#input\_logging\_target\_prefix) | Log prefix in target bucket | `string` | `"log/"` | no |
| <a name="input_object_ownership"></a> [object\_ownership](#input\_object\_ownership) | Object ownership control | `string` | `"BucketOwnerEnforced"` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Restrict public bucket policies | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags | `map(string)` | `{}` | no |
| <a name="input_versioning_status"></a> [versioning\_status](#input\_versioning\_status) | Versioning status (`Enabled`, `Suspended`, `Disabled`) | `string` | `"Enabled"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | Amazon Resource Name (ARN) of the bucket |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | Global domain name of the bucket |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The identifier/name of the bucket |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | Regional domain name of the bucket |
