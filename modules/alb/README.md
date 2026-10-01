# AWS Application Load Balancer (ALB) Terraform Module

A production-ready Terraform module to provision an AWS Application Load Balancer (ALB) with dynamic Target Groups, TLS/HTTPS listeners, automated HTTP-to-HTTPS redirects, and strict security groups.

## Features

- **TLS/HTTPS Best Practices**: Supports modern TLS 1.3/1.2 cipher suites (`ELBSecurityPolicy-TLS13-1-2-2021-06`) and automatic HTTP (port 80) to HTTPS (port 443) 301 permanent redirects.
- **Header Sanitization**: Enforces `drop_invalid_header_fields = true` to protect backend services from HTTP smuggling attacks.
- **Dynamic Target Registration**: Seamlessly binds to EC2 instances, IP targets, or ECS containers.
- **Configurable Health Checks**: Fine-grained health probe thresholds, intervals, timeouts, and HTTP response matchers.
- **Dedicated Security Group**: Auto-provisions an ingress security group for web traffic (80/443).

## Usage

```hcl
module "alb" {
  source = "../../modules/alb"

  name       = "app-production"
  vpc_id     = "vpc-0123456789abcdef0"
  subnets    = ["subnet-public-1a", "subnet-public-1b"]
  internal   = false

  target_port     = 80
  target_protocol = "HTTP"
  health_check_path = "/healthz"

  target_instance_ids = ["i-0123456789abcdef0"]

  tags = {
    Environment = "production"
    Tier        = "ingress"
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
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | Ingress CIDR blocks | `list(string)` | `["0.0.0.0/0"]` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ACM Certificate ARN | `string` | `null` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Create dedicated ALB SG | `bool` | `true` | no |
| <a name="input_drop_invalid_header_fields"></a> [drop\_invalid\_header\_fields](#input\_drop\_invalid\_header\_fields) | Drop invalid HTTP headers | `bool` | `true` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Enable deletion protection | `bool` | `false` | no |
| <a name="input_enable_https"></a> [enable\_https](#input\_enable\_https) | Enable HTTPS listener | `bool` | `false` | no |
| <a name="input_health_check_interval"></a> [health\_check\_interval](#input\_health\_check\_interval) | Health check interval (s) | `number` | `30` | no |
| <a name="input_health_check_matcher"></a> [health\_check\_matcher](#input\_health\_check\_matcher) | Healthy HTTP response code | `string` | `"200-399"` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Health check path | `string` | `"/"` | no |
| <a name="input_health_check_timeout"></a> [health\_check\_timeout](#input\_health\_check\_timeout) | Health check timeout (s) | `number` | `5` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Internal load balancer | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Load balancer name | `string` | n/a | yes |
| <a name="input_redirect_http_to_https"></a> [redirect\_http\_to\_https](#input\_redirect\_http\_to\_https) | Redirect HTTP to HTTPS | `bool` | `false` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | Existing SG IDs | `list(string)` | `[]` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | SSL Policy for HTTPS | `string` | `"ELBSecurityPolicy-TLS13-1-2-2021-06"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnet IDs for ALB | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags | `map(string)` | `{}` | no |
| <a name="input_target_instance_ids"></a> [target\_instance\_ids](#input\_target\_instance\_ids) | EC2 targets to register | `list(string)` | `[]` | no |
| <a name="input_target_port"></a> [target\_port](#input\_target\_port) | Backend target port | `number` | `80` | no |
| <a name="input_target_protocol"></a> [target\_protocol](#input\_target\_protocol) | Backend target protocol | `string` | `"HTTP"` | no |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | Target type (instance, ip, alb) | `string` | `"instance"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | ARN of Application Load Balancer |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | DNS name of Load Balancer |
| <a name="output_alb_id"></a> [alb\_id](#output\_alb\_id) | ID of Application Load Balancer |
| <a name="output_alb_zone_id"></a> [alb\_zone\_id](#output\_alb\_zone\_id) | Canonical hosted zone ID |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ALB security group ID |
| <a name="output_target_group_arn"></a> [target\_group\_arn](#output\_target\_group\_arn) | ARN of Target Group |
| <a name="output_target_group_name"></a> [target\_group\_name](#output\_target\_group\_name) | Name of Target Group |
