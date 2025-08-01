# AWS Terraform Nginx DevOps Stack

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

---

## Overview

This project provides a complete, production-ready AWS infrastructure stack using **Terraform** for Infrastructure as Code (IaC), **Nginx** as a web server, and a robust **CI/CD pipeline** via GitHub Actions. It demonstrates DevOps best practices for cloud provisioning, security, automation, and maintainability.

---

## Features

- **Modular AWS Network:** VPC, public/private subnets, NAT gateway, route tables, and internet gateway
- **Automated EC2 Provisioning:** Ubuntu server with Nginx installed via user-data
- **Secure Key Management:** SSH key pair generated and managed securely
- **Granular Security:** Security groups with least-privilege rules for HTTP, HTTPS, and SSH
- **CI/CD Pipeline:** Automated lint, validate, plan, and (optionally) apply via GitHub Actions
- **Best Practices:** Idempotent, reusable, and well-documented Terraform code
- **Sensitive Data Protection:** `.gitignore` excludes private keys and sensitive files

---

## Architecture

```text
[Internet]
    |
[Internet Gateway]
    |
[Public Subnet] ---- [NAT Gateway] ---- [Private Subnet]
    |
[EC2 Instance (Nginx)]
```

- **VPC**: Custom CIDR, DNS support
- **2x Public Subnets**: For high availability
- **2x Private Subnets**: For future expansion
- **NAT Gateway**: For private subnet outbound access
- **Elastic IP**: For NAT Gateway
- **Security Groups**: Web and (optionally) database

---

## Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/)
- AWS account with sufficient permissions
- [Git](https://git-scm.com/)

### Quickstart

1. **Clone the Repository**

   ```bash
   git clone https://github.com/matthewntsiful/aws-terraform-nginx.git
   cd aws-terraform-nginx
   ```

2. **Configure AWS Credentials**

   ```bash
   aws configure
   ```

3. **Create `terraform.tfvars`**

   ```hcl
   aws_region = "us-east-1"
   environment = "dev"
   instance_type = "t3.micro"
   public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
   private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
   ```

4. **Initialize Terraform**

   ```bash
   terraform init
   ```

5. **Plan and Apply**

   ```bash
   terraform plan
   terraform apply
   ```

6. **Access Nginx**

   - Find your EC2 instance's public IP or DNS in the Terraform outputs.
   - Visit `http://<public_ip>` in your browser.

---

## CI/CD Pipeline

This project includes a GitHub Actions workflow for automated Terraform operations:

- **Lint & Validate:** Ensures code quality and correctness for every PR and push to `main`
- **Plan:** Generates and uploads a Terraform plan artifact
- **Apply:** (Optional, manual approval) Applies changes to AWS on workflow dispatch
- **Excludes:** Workflow is not triggered by changes to docs, markdown, or scripts

**Secrets Required:**
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` must be set in your GitHub repo settings

**Workflow File:** `.github/workflows/web-tack.yaml`

---

## Security

- **SSH Keys:** Generated and stored locally, never committed to git
- **Security Groups:** Only essential ports are open (80, 443, 22)
- **Private Keys:** Add to `.gitignore` (see example in repo)
- **IAM:** Use least-privilege policies for CI/CD credentials

---

## Clean Up

To destroy all resources and avoid AWS charges:

```bash
terraform destroy
```

---

## Troubleshooting

- **Region/AZ Errors:** Ensure your AWS account supports the chosen region and availability zones.
- **Credential Issues:** Double-check your AWS CLI and GitHub secrets.

---

## Contributing

1. Fork the repo and create a branch
2. Make your changes with clear commit messages
3. Open a Pull Request for review

---

## License

Distributed under the MIT License. See `LICENSE` for details.

---

## Contact

Maintained by [Matthew Ntsiful](mailto:matthew.ntsiful@gmail.com)

---

### Code Comments and Docstrings

- **Code Comments:** Briefly explain the purpose of each Terraform resource and configuration option.
- **Docstrings:** Include a brief summary and notes on usage for each Terraform module.

This project uses [Terraform Doc](https://github.com/segmentio/terraform-doc) to generate documentation from code comments and docstrings.