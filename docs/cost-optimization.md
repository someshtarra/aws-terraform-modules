# AWS Cost Optimization & FinOps Guide

Deploying enterprise infrastructure with Terraform requires proactive cost management. This guide outlines how these modules are architected to reduce cloud spend without sacrificing performance or availability.

---

## 1. NAT Gateway Strategy

**The Challenge:**
Each AWS NAT Gateway costs approximately \$32.85/month in fixed hourly charges (in `us-east-1`), plus \$0.045 per GB of data processed. Deploying 3 NAT Gateways across 3 Availability Zones immediately introduces ~\$100/month in baseline network overhead before any traffic flows.

**The Solution:**
Our `modules/vpc` module supports toggling between high-availability and cost-optimized architectures:
```hcl
# For Dev / Staging: Shares 1 NAT Gateway across all AZs (~$32.85/mo total)
enable_nat_gateway = true
single_nat_gateway = true

# For Production: Dedicated NAT Gateway per AZ for maximum fault tolerance
enable_nat_gateway = true
single_nat_gateway = false
```

---

## 2. S3 Bucket Keys for KMS Encryption

**The Challenge:**
Standard AWS KMS requests cost \$0.03 per 10,000 requests. High-throughput workloads reading or writing millions of objects to S3 with SSE-KMS encryption can generate significant KMS request bills.

**The Solution:**
Our `modules/s3` module enables **S3 Bucket Keys** by default:
```hcl
bucket_key_enabled = true
```
This generates a short-lived bucket-level key inside S3, reducing roundtrip KMS API calls by **up to 99%**, slashing encryption costs from hundreds of dollars down to cents.

---

## 3. Storage Evolution: GP3 over GP2

**The Comparison:**
- **gp2**: Throughput and IOPS are bound to volume size. A 100 GB volume only provides 300 baseline IOPS. To get 3,000 IOPS, you are forced to overprovision to a 1,000 GB volume.
- **gp3**: Decouples storage capacity from performance. Provides 3,000 baseline IOPS and 125 MB/s throughput out-of-the-box at **20% lower cost per GB** (\$0.08/GB vs \$0.10/GB).

**Implementation:**
All compute modules (`modules/ec2`, `modules/rds`, `modules/eks`) standardize on `gp3`.

---

## 4. Graviton Processor Adoption (ARM64)

**The Advantage:**
AWS Graviton3 and Graviton4 processors deliver up to **40% better price-to-performance** compared to equivalent x86 instances, alongside lower power consumption.

**Implementation:**
- RDS default instance class is configured to `db.t4g.micro` / `db.t4g.small` (Graviton).
- EC2 and EKS can be swapped to `t4g`, `c7g`, or `m7g` instance types seamlessly.

---

## 5. Automated Data Lifecycle & Retention

Unmanaged logs and object version histories create silent, compounding storage debt.

### S3 Noncurrent Version Expiration
```hcl
enable_lifecycle_rules             = true
noncurrent_version_transition_days = 30 # Transitions to STANDARD_IA
noncurrent_version_expiration_days = 90 # Deletes obsolete versions completely
```

### CloudWatch Log Retention
By default, CloudWatch log groups never expire logs, leading to runaway storage fees.
Our modules enforce explicit expiration policies:
```hcl
log_retention_in_days = 14 # 14 to 30 days for application and flow logs
```

---

## 6. EKS Spot Worker Nodes

For stateless Kubernetes workloads, batch jobs, or testing environments, `modules/eks` allows provisioning EC2 Spot Instances with up to **90% discount** compared to On-Demand pricing:

```hcl
node_capacity_type = "SPOT"
node_instance_types = ["t3.medium", "t3a.medium"]
```
