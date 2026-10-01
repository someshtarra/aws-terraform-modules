# Basic EC2 Example

This example demonstrates how to deploy a standalone Amazon Linux 2023 EC2 web server using the `modules/ec2` module.

## Architecture

- Uses latest Amazon Linux 2023 AMI.
- Automatically resolves the Default VPC and Subnet if none are provided.
- Configures an automated Nginx web server installation via user-data.
- Secures the instance with IMDSv2 and an encrypted gp3 EBS root volume.
- Provisions a dedicated security group permitting inbound HTTP (port 80).

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

4. Clean up resources:
   ```bash
   terraform destroy
   ```
