# Contributing to AWS Terraform Modules

Thank you for your interest in contributing to **`aws-terraform-modules`**! We welcome contributions from DevOps engineers, cloud architects, and developers of all backgrounds.

---

## Code of Conduct

We are committed to providing a welcoming, inclusive, and harassment-free environment for everyone. Please be respectful and constructive in all discussions, pull requests, and issues.

---

## Getting Started

1. **Fork the repository** on GitHub.
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/someshtarra/aws-terraform-modules.git
   cd aws-terraform-modules
   ```
3. **Create a new feature branch**:
   ```bash
   git checkout -b feat/add-sqs-module
   ```

---

## Development Standards & Guidelines

### 1. Module Structure
Every module inside `modules/<name>/` must contain the following standard files:
- `main.tf`: Core resource declarations and logic.
- `variables.tf`: Input variable definitions with descriptive text, types, sensible defaults, and validation blocks where appropriate.
- `outputs.tf`: Exported attributes with descriptions.
- `versions.tf`: Minimum required Terraform version (`>= 1.5.0`) and AWS provider (`>= 5.0.0`).
- `README.md`: Auto-generated or hand-crafted markdown detailing requirements, providers, inputs, outputs, and usage examples.

### 2. Terraform Conventions
- **Canonical Formatting**: Run `terraform fmt -recursive` before committing.
- **Resource Naming**: Use snake_case for resource identifiers (e.g., `aws_s3_bucket.this`).
- **Tagging**: Tag all taggable resources with `ManagedBy = "Terraform"` and merge with `var.tags`.
- **Security First**:
  - Encrypt all data at rest using AWS KMS or AES-256.
  - Never open security group rules to `0.0.0.0/0` unless explicitly intended for public ingress (e.g., ALB HTTP/HTTPS).
  - Enforce IMDSv2 on compute workloads.
  - Never commit credentials, secrets, private keys, or `.tfstate` files.

### 3. Local Verification

Run the following checks before opening a pull request:

```bash
# 1. Check code formatting
terraform fmt -check -recursive

# 2. Validate configuration across all modules
for dir in modules/* examples/*; do
  if [ -d "$dir" ]; then
    echo "Validating $dir..."
    (cd "$dir" && terraform init -backend=false && terraform validate)
  fi
done

# 3. Static security analysis (if tools are installed)
tflint --recursive
trivy config .
```

---

## Commit Message Conventions

We adhere to the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` A new module or feature (e.g., `feat(eks): add support for Karpenter node pools`)
- `fix:` A bug fix (e.g., `fix(s3): correct bucket policy condition for TLS enforcement`)
- `docs:` Documentation improvements (e.g., `docs(readme): add architecture flow diagram`)
- `refactor:` Code restructuring without functional changes (e.g., `refactor(vpc): simplify NAT gateway locals`)
- `ci:` Changes to CI/CD workflows (e.g., `ci: upgrade trivy action to v0.20`)

---

## Submitting a Pull Request

1. Ensure all CI checks pass.
2. Include a clear title and description explaining what changes were made and why.
3. Link any related issues or discussions.
4. Keep pull requests focused on a single logical change.
