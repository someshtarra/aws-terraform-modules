# Enterprise Full-Stack AWS Architecture Example

This example demonstrates how all modules in this repository interconnect seamlessly to provision a secure, highly available, multi-tier cloud infrastructure on AWS.

## Architecture Highlights

```text
[ Internet Users ]
       │ (HTTPS / HTTP:80)
       ▼
[ Application Load Balancer ] (Public Subnets)
       │ (HTTP:80 Security Group Chained)
       ▼
[ EC2 Application Tier ] (Private Subnets)
   ├── IAM Role: SSM + S3 Object Access + KMS Decrypt
   ├── Storage: Encrypted gp3 Root EBS via KMS CMK
   └── Telemetry: CloudWatch Metric Alarms (CPU > 80%)
       │
       ├─────────────────────────────────┐
       │ (MySQL:3306 Restricted Ingress)  │ (HTTPS TLS via Gateway Endpoint / NAT)
       ▼                                 ▼
[ RDS Multi-AZ Database ]         [ Secure S3 Bucket ]
  (Isolated Database Subnets)       (KMS CMK Encrypted, TLS-enforced, Versioned)
```

- **Zero Hardcoded IDs**: Modules communicate purely through resource outputs and inputs (e.g. `module.vpc.vpc_id`, `module.alb.security_group_id`, `module.kms.key_arn`).
- **Defense in Depth**:
  - Web EC2 instances reside inside **Private Subnets** with no public IP.
  - Load balancer security group forwards traffic only to the compute layer.
  - RDS MySQL resides in **Isolated Database Subnets** and allows traffic **exclusively** from the EC2 security group ID.
  - S3 bucket denies non-SSL requests and is encrypted with a dedicated KMS Customer Managed Key.
  - EC2 runs IMDSv2 to prevent SSRF credential theft.

## Deployment Steps

1. Configure variables:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Modify db_password or other parameters as required
   ```

2. Initialize Terraform providers and local modules:
   ```bash
   terraform init
   ```

3. Review the execution plan:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

5. Verify application:
   - Note `alb_dns_name` output.
   - Access `http://<alb_dns_name>` in your browser or via curl.

6. Clean up:
   ```bash
   terraform destroy
   ```
