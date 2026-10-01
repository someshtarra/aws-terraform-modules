# AWS EC2 Terraform Module

A production-grade, security-hardened Terraform module to provision AWS Elastic Compute Cloud (EC2) instances, integrated security groups, encrypted EBS volumes, key pairs, and bootstrap user-data scripts.

## Features

- **SSRF Hardened via IMDSv2**: Enforces `http_tokens = "required"` and restricts `http_put_response_hop_limit = 1` by default to thwart Server-Side Request Forgery vulnerabilities.
- **EBS Encryption by Default**: Root device and additional data volumes are encrypted using AWS KMS with `gp3` high-performance volumes.
- **Dynamic Security Groups**: Configurable ingress and egress rule definitions supporting CIDR blocks and referenced security group IDs.
- **Automatic Amazon Linux 2023 Resolution**: Uses the latest official AL2023 AMI automatically if an explicit `ami_id` is omitted.
- **Key Pair Support**: Supports reusing existing key pairs or provisioning a new key pair inline via public key material.
- **IAM Instance Profile**: Seamlessly attaches an IAM profile for AWS Systems Manager (SSM) agent management.

## Usage

```hcl
module "ec2_app_server" {
  source = "../../modules/ec2"

  name          = "payment-service-worker"
  instance_type = "t3.small"
  subnet_id     = "subnet-0123456789abcdef0"
  vpc_id        = "vpc-0123456789abcdef0"

  associate_public_ip_address = false
  iam_instance_profile        = "web-server-ec2-role-instance-profile"

  user_data = <<-EOF
              #!/bin/bash
              echo "Starting App Server..." > /var/log/bootstrap.log
              dnf update -y
              dnf install -y nginx
              systemctl enable --now nginx
              EOF

  create_security_group = true
  security_group_ingress_rules = [
    {
      description = "Allow HTTP from internal ALB"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  root_volume_size = 50
  root_volume_type = "gp3"

  tags = {
    Environment = "production"
    Tier        = "backend"
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
| <a name="input_additional_ebs_device_name"></a> [additional\_ebs\_device\_name](#input\_additional\_ebs\_device\_name) | Device name for additional EBS | `string` | `"/dev/xvdf"` | no |
| <a name="input_additional_ebs_kms_key_id"></a> [additional\_ebs\_kms\_key\_id](#input\_additional\_ebs\_kms\_key\_id) | KMS key for additional EBS | `string` | `null` | no |
| <a name="input_additional_ebs_volume_size"></a> [additional\_ebs\_volume\_size](#input\_additional\_ebs\_volume\_size) | Size of additional EBS volume (GB) | `number` | `50` | no |
| <a name="input_additional_ebs_volume_type"></a> [additional\_ebs\_volume\_type](#input\_additional\_ebs\_volume\_type) | Type of additional EBS volume | `string` | `"gp3"` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID (defaults to latest AL2023) | `string` | `null` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Associate public IP | `bool` | `false` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Create dedicated security group | `bool` | `true` | no |
| <a name="input_enable_additional_ebs_volume"></a> [enable\_additional\_ebs\_volume](#input\_enable\_additional\_ebs\_volume) | Attach additional EBS volume | `bool` | `false` | no |
| <a name="input_enable_detailed_monitoring"></a> [enable\_detailed\_monitoring](#input\_enable\_detailed\_monitoring) | Enable detailed monitoring | `bool` | `false` | no |
| <a name="input_enable_imds_v2"></a> [enable\_imds\_v2](#input\_enable\_imds\_v2) | Enforce IMDSv2 token requirement | `bool` | `true` | no |
| <a name="input_existing_security_group_ids"></a> [existing\_security\_group\_ids](#input\_existing\_security\_group\_ids) | Existing SGs to attach | `list(string)` | `[]` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | IAM Instance Profile name | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type | `string` | `"t3.micro"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Existing Key Pair name | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name identifier for resources | `string` | n/a | yes |
| <a name="input_public_key"></a> [public\_key](#input\_public\_key) | SSH public key to create key pair | `string` | `null` | no |
| <a name="input_root_kms_key_id"></a> [root\_kms\_key\_id](#input\_root\_kms\_key\_id) | KMS key for root EBS | `string` | `null` | no |
| <a name="input_root_volume_encrypted"></a> [root\_volume\_encrypted](#input\_root\_volume\_encrypted) | Encrypt root volume | `bool` | `true` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | Root volume size (GB) | `number` | `30` | no |
| <a name="input_root_volume_type"></a> [root\_volume\_type](#input\_root\_volume\_type) | Root volume type | `string` | `"gp3"` | no |
| <a name="input_security_group_egress_rules"></a> [security\_group\_egress\_rules](#input\_security\_group\_egress\_rules) | Security group egress rules | `list(object)` | `[...]` | no |
| <a name="input_security_group_ingress_rules"></a> [security\_group\_ingress\_rules](#input\_security\_group\_ingress\_rules) | Security group ingress rules | `list(object)` | `[]` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet ID to launch in | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags | `map(string)` | `{}` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | Startup user data script | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID for SG creation | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_ebs_volume_id"></a> [additional\_ebs\_volume\_id](#output\_additional\_ebs\_volume\_id) | ID of additional EBS volume |
| <a name="output_instance_arn"></a> [instance\_arn](#output\_instance\_arn) | ARN of the EC2 instance |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | ID of the EC2 instance |
| <a name="output_key_pair_name"></a> [key\_pair\_name](#output\_key\_pair\_name) | Key pair name used |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | Private IP address |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Public IP address |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | ARN of security group created |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of security group created |
