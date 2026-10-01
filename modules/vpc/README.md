# AWS VPC Terraform Module

A production-grade, highly scalable Terraform module to provision an Amazon Virtual Private Cloud (VPC) with Multi-AZ Public, Private, and Isolated Database Subnets, NAT Gateways, Internet Gateway, Route Tables, and optional VPC Flow Logs.

## Features

- **Multi-AZ Network Architecture**: Provisions subnets distributed evenly across selected Availability Zones.
- **Three-Tier Subnet Segmentation**:
  - **Public Subnets**: Direct route to Internet Gateway for ALBs, Bastions, and NAT Gateways.
  - **Private Subnets**: Egress-only internet access routed via NAT Gateways for compute (EC2/EKS/ECS).
  - **Database Subnets**: Fully isolated subnets with zero internet routes for compliance-sensitive persistence (RDS/ElastiCache).
- **Cost-Optimized NAT Gateway Topology**:
  - `single_nat_gateway = true`: Shares 1 NAT Gateway across all AZs (ideal for non-production environments to minimize hourly NAT charges).
  - `single_nat_gateway = false`: Provisions a dedicated NAT Gateway per AZ for maximum high-availability and fault tolerance in production.
- **RDS Subnet Group**: Automatically provisions an `aws_db_subnet_group` whenever database subnets are specified.
- **VPC Flow Logs**: Optional built-in telemetry to CloudWatch Logs or S3.

## Usage

```hcl
module "vpc" {
  source = "../../modules/vpc"

  name = "production-app"
  cidr_block = "10.0.0.0/16"

  azs              = ["us-east-1a", "us-east-1b"]
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.10.0/24", "10.0.20.0/24"]
  database_subnets = ["10.0.30.0/24", "10.0.40.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true # Set to false in multi-AZ production for high availability

  tags = {
    Environment = "production"
    Project     = "enterprise-core"
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
| <a name="input_azs"></a> [azs](#input\_azs) | List of Availability Zones | `list(string)` | n/a | yes |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | IPv4 CIDR block for VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets) | CIDR blocks for isolated DB subnets | `list(string)` | `[]` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable DNS hostnames in VPC | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable DNS support in VPC | `bool` | `true` | no |
| <a name="input_enable_flow_log"></a> [enable\_flow\_log](#input\_enable\_flow\_log) | Enable VPC Flow Logs | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Provision NAT Gateways | `bool` | `true` | no |
| <a name="input_flow_log_destination_arn"></a> [flow\_log\_destination\_arn](#input\_flow\_log\_destination\_arn) | Destination ARN for VPC flow logs | `string` | `null` | no |
| <a name="input_flow_log_destination_type"></a> [flow\_log\_destination\_type](#input\_flow\_log\_destination\_type) | Destination type (cloud-watch-logs, s3) | `string` | `"cloud-watch-logs"` | no |
| <a name="input_map_public_ip_on_launch"></a> [map\_public\_ip\_on_launch](#input\_map\_public\_ip\_on\_launch) | Auto-assign public IPs in public subnets | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name prefix for VPC resources | `string` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | CIDR blocks for private subnets | `list(string)` | `[]` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | CIDR blocks for public subnets | `list(string)` | `[]` | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Use single NAT gateway across all AZs | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_subnet_group_id"></a> [database\_subnet\_group\_id](#output\_database\_subnet\_group\_id) | ID of DB subnet group |
| <a name="output_database_subnet_group_name"></a> [database\_subnet\_group\_name](#output\_database\_subnet\_group\_name) | Name of DB subnet group |
| <a name="output_database_subnet_ids"></a> [database\_subnet\_ids](#output\_database\_subnet\_ids) | IDs of database subnets |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | ID of Internet Gateway |
| <a name="output_nat_gateway_ids"></a> [nat\_gateway\_ids](#output\_nat\_gateway\_ids) | IDs of NAT Gateways |
| <a name="output_nat_gateway_public_ips"></a> [nat\_gateway\_public\_ips](#output\_nat\_gateway\_public\_ips) | Elastic IPs of NAT Gateways |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | IDs of private route tables |
| <a name="output_private_subnet_arns"></a> [private\_subnet\_arns](#output\_private\_subnet\_arns) | ARNs of private subnets |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | IDs of private subnets |
| <a name="output_public_route_table_id"></a> [public\_route\_table\_id](#output\_public\_route\_table\_id) | ID of public route table |
| <a name="output_public_subnet_arns"></a> [public\_subnet\_arns](#output\_public\_subnet\_arns) | ARNs of public subnets |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | IDs of public subnets |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | ARN of VPC |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | IPv4 CIDR block of VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of VPC |
