# LinkedIn Project Announcement

Copy and paste this post to share your project with recruiters, engineering leaders, and the DevOps / Cloud community on LinkedIn!

---

🚀 **Excited to share my latest open-source project: AWS Terraform Modules!**

As cloud environments grow in complexity, managing infrastructure through manual clicks or tightly-coupled scripts quickly leads to configuration drift, security vulnerabilities, and deployment friction.

To solve this, I built **`aws-terraform-modules`**—a production-grade, highly reusable collection of Infrastructure as Code (IaC) modules for AWS, engineered according to the AWS Well-Architected Framework and strict security benchmarks.

🔗 **GitHub Repository:** https://github.com/someshtarra/aws-terraform-modules

---

### 🌟 What’s inside?

✅ **10 Production-Ready AWS Modules:**
- **VPC:** 3-Tier Multi-AZ architecture (Public, Private, Isolated DB subnets) with NAT Gateways & Flow Logs
- **Security & IAM:** Least-privilege IAM roles, instance profiles, and KMS Customer Managed Keys with auto-rotation
- **Compute:** Hardened EC2 (IMDSv2 enforced, encrypted gp3 EBS) and EKS (v1.30, IRSA OIDC, envelope secrets encryption)
- **Persistence:** Multi-AZ RDS (MySQL/PostgreSQL) with storage autoscaling & S3 with enforced TLS and S3 Bucket Keys
- **Traffic & Observability:** Application Load Balancer with TLS 1.3, Lambda serverless, and CloudWatch alarms & dashboards

✅ **Real-World Full-Stack Architecture:**
- A complete multi-tier example connecting VPC, ALB, EC2, RDS, S3, KMS, and CloudWatch purely via module outputs—**zero hardcoded IDs**.

✅ **Automated DevOps & CI/CD:**
- GitHub Actions workflows for `terraform fmt`, `terraform validate`, TFLint, and automated security scans using **Trivy** and **Checkov**.
- Keyless AWS deployment using **GitHub Actions OIDC** federation.

✅ **FinOps & Cost Optimization:**
- Built-in support for S3 Bucket Keys (99% KMS cost reduction), single NAT gateway toggles, and ARM-based AWS Graviton processors.

---

### 🛠️ Tech Stack:
Terraform | AWS | GitHub Actions | Docker / Kubernetes (EKS) | DevSecOps | Checkov | Trivy | FinOps

Check out the repository, star ⭐ it if you find it helpful, and feel free to contribute or share your feedback!

#AWS #Terraform #DevOps #CloudComputing #InfrastructureAsCode #CloudSecurity #Kubernetes #FinOps #OpenSource #SoftwareEngineering #CloudArchitecture
