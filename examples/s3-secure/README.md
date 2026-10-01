# Secure S3 Bucket Example

This example demonstrates deploying a hardened, CIS-compliant AWS S3 bucket encrypted with a dedicated AWS KMS Customer Managed Key (CMK), with S3 Bucket Keys, TLS transport enforcement, and noncurrent version lifecycle management.

## Key Security Controls

- **KMS CMK**: Created with automatic key rotation enabled.
- **Bucket Key**: Lowers AWS KMS API request costs by up to 99%.
- **TLS 1.2+ Only**: Explicit bucket policy denies all non-secure (`http://`) requests.
- **Public Access Block**: All four public access block settings activated.
- **Lifecycle Expiration**: Transitions older object versions to Infrequent Access (`STANDARD_IA`) and deletes noncurrent versions after 90 days.

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
