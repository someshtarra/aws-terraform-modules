# AWS Security & Compliance Best Practices

This guide documents the defense-in-depth security standards implemented across the **`aws-terraform-modules`** repository.

---

## 1. Identity & Access Management (IAM)

### Principle of Least Privilege (PoLP)
- All IAM roles only receive permissions explicitly necessary for their runtime function.
- Avoid wildcard `*` resources in write and admin actions; scope down to specific ARNs.

### IAM Roles over Long-Lived Access Keys
- **No static AWS Access Keys (`AKIA...`)** are ever generated or stored in code.
- EC2 compute uses **IAM Instance Profiles** to interact with AWS APIs.
- EKS pods utilize **IAM Roles for Service Accounts (IRSA)** backed by an OIDC provider.
- CI/CD workflows utilize **GitHub Actions OpenID Connect (OIDC)** token exchange to assume temporary AWS STS credentials dynamically.

```hcl
# Example IRSA trust policy dynamically verified via OIDC
data "aws_iam_policy_document" "irsa" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_issuer_url}:sub"
      values   = ["system:serviceaccount:default:my-app-sa"]
    }
  }
}
```

---

## 2. Network Security & Segmentation

### Strict Tiered Subnet Isolation
- **Public Subnet**: Reserved only for reverse proxies (ALB) and outbound NAT Gateways.
- **Private Subnet**: Application compute instances have no public IPv4 addresses and can only initiate outbound internet traffic via NAT.
- **Database Subnet**: Isolated with zero internet gateway or NAT routes.

### Security Group Chaining
- Compute security groups do **not** open ports to `0.0.0.0/0`.
- EC2 instances allow incoming HTTP traffic **exclusively from the ALB Security Group ID**:
  ```hcl
  security_groups = [module.alb.security_group_id]
  ```
- RDS instances accept database connections **exclusively from the EC2 Security Group ID**:
  ```hcl
  security_groups = [module.ec2.security_group_id]
  ```

---

## 3. Data Protection & Cryptography

### Encryption at Rest
- **EBS Volumes**: Root and additional block volumes are encrypted using AWS KMS.
- **RDS Databases**: Storage is encrypted using AES-256 via KMS Customer Managed Keys (CMK).
- **Amazon S3**: Server-side encryption with KMS keys (`aws:kms`) and S3 Bucket Keys enabled.
- **Kubernetes Secrets**: EKS envelope encryption protects Kubernetes secrets at rest with KMS.

### Automated Key Rotation
- All Customer Managed Keys enforce annual automatic key rotation:
  ```hcl
  enable_key_rotation = true
  ```

### Encryption in Transit
- **Enforced TLS on S3**: Bucket policy explicitly denies any request without SSL transport:
  ```json
  {
    "Sid": "EnforceTLSRequestsOnly",
    "Effect": "Deny",
    "Principal": "*",
    "Action": "s3:*",
    "Resource": ["arn:aws:s3:::bucket-name/*"],
    "Condition": {
      "Bool": {
        "aws:SecureTransport": "false"
      }
    }
  }
  ```
- **ALB HTTPS Listeners**: Modern SSL policies (`ELBSecurityPolicy-TLS13-1-2-2021-06`) restrict legacy, vulnerable ciphers and enforce TLS 1.2 or TLS 1.3.

---

## 4. Compute Hardening (EC2 & EKS)

### EC2 Metadata Service Protection (IMDSv2)
- Prevents Server-Side Request Forgery (SSRF) vulnerabilities from stealing IAM instance credentials.
- Configured with `http_tokens = "required"` and `http_put_response_hop_limit = 1`.

### Elimination of SSH Ports
- EC2 instances do not require open port 22.
- Instances include `AmazonSSMManagedInstanceCore` policy for secure, auditable terminal access via AWS Systems Manager Session Manager.

---

## 5. Automated Security Audits in CI/CD

Every commit and pull request runs automated security linting:
- **Trivy**: Comprehensive vulnerability and IaC misconfiguration scanner.
- **Checkov**: Static analysis against CIS AWS Benchmark, SOC2, and PCI-DSS standards.
- **TFLint**: Enforces Terraform best practices and flags deprecated attributes.
