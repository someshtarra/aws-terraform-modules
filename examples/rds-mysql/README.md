# RDS MySQL Example

This example demonstrates deploying an AWS RDS MySQL 8.0 instance inside an isolated VPC database subnet group, encrypted using an AWS KMS Customer Managed Key.

## Features Illustrated

- **Isolated Subnet Placement**: Deployed strictly inside private database subnets without public IP or internet routing.
- **KMS Storage Encryption**: Data at rest is encrypted using a dedicated CMK with key rotation.
- **Storage Autoscaling**: Automatically scales up to 50 GB under storage load.
- **Cross-Module Wiring**: Demonstrates consuming subnet group outputs from `modules/vpc` directly in `modules/rds`.

## How to Run

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review execution plan:
   ```bash
   terraform plan
   ```

3. Apply configuration:
   ```bash
   terraform apply
   ```

4. Clean up:
   ```bash
   terraform destroy
   ```
