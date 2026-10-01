# VPC Public & Private Subnets Example

This example demonstrates deploying a production-ready, highly available Multi-AZ AWS Virtual Private Cloud (VPC) featuring public, private application, and isolated database subnets, NAT Gateway routing, and integrated VPC Flow Logs.

## Architecture

- **Public Subnets**: Ingress zone for ALBs and NAT Gateways with direct routing to the Internet Gateway.
- **Private Subnets**: Compute zone for EC2/EKS with egress-only outbound routing through the NAT Gateway.
- **Database Subnets**: Completely isolated tier without internet routes, bundled into an automated RDS Subnet Group.
- **VPC Flow Logs**: Captures IP traffic telemetry sent securely to Amazon CloudWatch Logs for audit compliance.

## How to Run

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review execution plan:
   ```bash
   terraform plan
   ```

3. Deploy resources:
   ```bash
   terraform apply
   ```

4. Clean up:
   ```bash
   terraform destroy
   ```
