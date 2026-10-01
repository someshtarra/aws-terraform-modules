# AWS EKS Terraform Module

A production-grade, hardened Terraform module to provision an Amazon Elastic Kubernetes Service (EKS) cluster and AWS Managed Node Groups with automated OIDC provider configuration for IAM Roles for Service Accounts (IRSA), envelope encryption for Kubernetes secrets, and control plane logging.

## Features

- **Kubernetes 1.30 Ready**: Configured for modern Kubernetes versions with rolling worker node updates (`max_unavailable = 1`).
- **Secrets Encryption**: Supports AWS KMS Customer Managed Keys (CMK) envelope encryption for Kubernetes secrets at rest.
- **IAM Roles for Service Accounts (IRSA)**: Automatically provisions an OpenID Connect (OIDC) identity provider for pod-level AWS IAM identity federation.
- **Control Plane Logging**: Enables comprehensive audit, API, authenticator, scheduler, and controllerManager logging to CloudWatch.
- **Least-Privilege Node & Cluster Roles**: Separate, dedicated IAM roles for control plane and worker nodes adhering strictly to AWS security guidance.

## Usage

```hcl
module "eks" {
  source = "../../modules/eks"

  cluster_name    = "prod-workloads"
  cluster_version = "1.30"
  vpc_id          = "vpc-0123456789abcdef0"
  subnet_ids      = ["subnet-private-1a", "subnet-private-1b"]

  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/abcd-1234-efgh"

  node_group_name     = "system-workers"
  node_instance_types = ["t3.medium"]
  node_capacity_type  = "ON_DEMAND"
  node_desired_size   = 3
  node_min_size       = 2
  node_max_size       = 6

  enable_irsa = true

  tags = {
    Environment = "production"
    Tier        = "kubernetes"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_enabled_log_types"></a> [cluster\_enabled\_log\_types](#input\_cluster\_enabled\_log\_types) | Control plane logs to enable | `list(string)` | `["api", "audit", ...]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes version | `string` | `"1.30"` | no |
| <a name="input_enable_irsa"></a> [enable\_irsa](#input\_enable\_irsa) | Create OIDC provider for IRSA | `bool` | `true` | no |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | Enable private API server endpoint | `bool` | `true` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | Enable public API server endpoint | `bool` | `true` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS Key ARN for secrets encryption | `string` | `null` | no |
| <a name="input_node_capacity_type"></a> [node\_capacity\_type](#input\_node\_capacity\_type) | Capacity type (`ON_DEMAND`, `SPOT`) | `string` | `"ON_DEMAND"` | no |
| <a name="input_node_desired_size"></a> [node\_desired\_size](#input\_node\_desired\_size) | Desired worker nodes | `number` | `2` | no |
| <a name="input_node_disk_size"></a> [node\_disk\_size](#input\_node\_disk\_size) | Disk size in GiB for nodes | `number` | `50` | no |
| <a name="input_node_group_name"></a> [node\_group\_name](#input\_node\_group\_name) | Managed node group name | `string` | `"general-workers"` | no |
| <a name="input_node_instance_types"></a> [node\_instance\_types](#input\_node\_instance\_types) | Node instance types | `list(string)` | `["t3.medium"]` | no |
| <a name="input_node_max_size"></a> [node\_max\_size](#input\_node\_max\_size) | Maximum worker nodes | `number` | `5` | no |
| <a name="input_node_min_size"></a> [node\_min\_size](#input\_node\_min\_size) | Minimum worker nodes | `number` | `1` | no |
| <a name="input_public_access_cidrs"></a> [public\_access\_cidrs](#input\_public\_access\_cidrs) | CIDR blocks for public API access | `list(string)` | `["0.0.0.0/0"]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs for control plane & nodes | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ARN of EKS cluster |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | CA data for cluster API |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Kubernetes API endpoint |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | ID of EKS cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of EKS cluster |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | Security group ID created by EKS |
| <a name="output_node_group_arn"></a> [node\_group\_arn](#output\_node\_group\_arn) | ARN of Managed Node Group |
| <a name="output_node_group_id"></a> [node\_group\_id](#output\_node\_group\_id) | ID of Managed Node Group |
| <a name="output_oidc_issuer_url"></a> [oidc\_issuer\_url](#output\_oidc\_issuer\_url) | OIDC Issuer URL |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | ARN of OIDC provider for IRSA |
