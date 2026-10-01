# AWS Infrastructure Architecture Guide

This document outlines the architectural blueprints, design decisions, and Well-Architected Framework alignments embodied across the **`aws-terraform-modules`** repository.

---

## 1. High-Level Architectural Overview

The modules are built following a **Modular Multi-Tier Layered Architecture** that decouples network topology, storage security, identity governance, compute execution, and monitoring.

![AWS Architecture Diagram](../images/architecture-diagram.png)

### Key Architectural Layers

1. **Edge & Ingress (Public Tier)**:
   - **Internet Gateway & Public Subnets**: Exclusively hosts public ingress components—namely Application Load Balancers (ALB) and NAT Gateways.
   - **Application Load Balancer**: Terminates client connections, drops invalid HTTP headers, enforces TLS 1.3/1.2 ciphers, and forwards traffic across multiple Availability Zones to target groups.

2. **Application & Compute (Private Tier)**:
   - **Private Subnets**: No public IP addresses assigned.
   - **EC2 / EKS**: Compute workloads run strictly in private subnets. Outbound internet connectivity (for package updates, container image pulls, or external APIs) flows through NAT Gateways.
   - **Instance Profiles & Roles**: Authenticated via AWS IAM with least privilege; management handled out-of-band via AWS Systems Manager (SSM) Session Manager without requiring open SSH port 22.

3. **Persistence & Data Tier (Isolated Tier)**:
   - **Database Subnets**: Dedicated subnets containing zero route tables to the internet or NAT Gateways.
   - **RDS Multi-AZ**: High-availability database deployments spanning multiple Availability Zones with synchronous replication and automated failover.
   - **EBS & RDS Storage**: Encrypted at rest with AWS KMS Customer Managed Keys (CMK).

4. **Object Storage Tier**:
   - **Amazon S3**: Hardened object storage with Bucket Keys enabled, default SSE-KMS encryption, versioning, object ownership enforcement, and transport security policy denying non-HTTPS traffic.

5. **Observability & Management**:
   - **CloudWatch Logs**: Centralized logging for VPC Flow Logs, EC2 system logs, Lambda executions, and EKS audit logs with automated retention policies.
   - **CloudWatch Alarms & Dashboards**: Proactive alerting on CPU, memory, database IOPS, and ALB 5XX error rates.

---

## 2. Reusable Modular Topology

![Terraform Modules Diagram](../images/terraform-modules-diagram.png)

Each module is designed as an independent, loosely coupled building block adhering to the **Single Responsibility Principle (SRP)**:

- `modules/vpc` exports `vpc_id`, subnet IDs, and database subnet group names.
- `modules/kms` exports `key_arn` consumed by S3, RDS, EBS, and EKS.
- `modules/iam` exports role and instance profile names consumed by EC2 and Lambda.
- `modules/alb` exports `security_group_id` and target group ARNs.
- `modules/ec2` accepts ALB security group IDs to create chained, zero-trust ingress rules.
- `modules/rds` accepts EC2 security group IDs, isolating database access strictly to the compute layer.

---

## 3. Alignment with AWS Well-Architected Framework

### Pillar 1: Operational Excellence
- Everything is managed declaratively as code (IaC).
- Automated CI/CD validation ensures continuous syntax and policy compliance before merging.
- Operational dashboards and metric alarms are deployed alongside compute resources.

### Pillar 2: Security
- **Defense in depth**: Multiple security boundaries (NACLs, Security Groups, IAM Policies, Bucket Policies, Key Policies).
- **Zero hardcoded credentials**: Native integration with AWS IAM Instance Profiles, IRSA, and GitHub OIDC federation.
- **Encryption everywhere**: AES-256 or KMS CMK with automated annual key rotation.
- **IMDSv2**: Mandatory across EC2 instances to neutralize SSRF vectors.

### Pillar 3: Reliability
- **Multi-AZ by default**: Subnets distributed across multiple AZs (`us-east-1a`, `us-east-1b`, etc.).
- **Health probes**: Application Load Balancers continuously monitor backend health and route away from unhealthy nodes.
- **Auto-healing**: RDS automated Multi-AZ standby failover within 60 seconds of hardware degradation.

### Pillar 4: Performance Efficiency
- **Modern instance families**: Uses AWS Graviton (`db.t4g`, `t4g`) and modern Nitro instances (`t3`, `m6i`).
- **Next-generation storage**: Defaulting to `gp3` EBS volumes providing baseline 3,000 IOPS and 125 MB/s throughput decoupled from storage volume size.

### Pillar 5: Cost Optimization
- **S3 Bucket Keys**: Reduces KMS API request volume and billings by up to 99%.
- **Single NAT Gateway Option**: Allows non-production environments to avoid redundant NAT Gateway hourly charges.
- **Automated Lifecycle Transitions**: Transitions non-current object versions to Infrequent Access and Glacier tiers before expiration.

### Pillar 6: Sustainability
- Utilizing energy-efficient AWS Graviton processors (up to 60% less energy consumed for the same workloads).
- Automated log expiration to prevent unnecessary data retention.
