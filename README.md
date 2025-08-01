# AWS Terraform Nginx DevOps Stack

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![CI/CD](https://img.shields.io/badge/CI%2FCD-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)
![IaC](https://img.shields.io/badge/Infrastructure_as_Code-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Automation](https://img.shields.io/badge/Automation-4CAF50?style=for-the-badge&logo=automation&logoColor=white)

## 🚀 DevOps Infrastructure Stack

Production-ready AWS infrastructure demonstrating modern DevOps practices with Infrastructure as Code (IaC), automated CI/CD pipelines, security best practices, and comprehensive monitoring solutions.

**Status**: ✅ **DEPLOYED & OPERATIONAL**

## ✨ Current Infrastructure

### 🏗️ Deployed Resources
- **VPC**: Custom network (10.0.0.0/16) with public/private subnets
- **EC2 Instance**: Ubuntu server with Nginx (t3.small)
- **Security Groups**: Web traffic (HTTP/HTTPS) and SSH access
- **Networking**: Internet Gateway, NAT Gateway, Route Tables
- **Remote State**: S3 bucket (`terraform-state-x82zf9vy`) with DynamoDB locking
- **SSH Key Pair**: Auto-generated for secure access

### 🔄 CI/CD Pipeline Status
- **Status**: ✅ Active and functional
- **Triggers**: Push to main branch or manual dispatch
- **Validation**: Format checking, syntax validation, security scanning
- **Deployment**: Automated infrastructure provisioning
- **State Management**: Shared remote state between local and CI/CD

## 🏛️ Architecture & Workflow

### CI/CD Workflow
```
┌─────────────────────────────────────────────────────────────────┐
│                        Developer Workflow                       │
└─────────────────────────────────────────────────────────────────┘
                                  │
                    ┌─────────────▼─────────────┐
                    │     git push origin main  │
                    └─────────────┬─────────────┘
                                  │
┌─────────────────────────────────▼─────────────────────────────────┐
│                      GitHub Actions Pipeline                      │
│                                                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌──────────┐ │
│  │ terraform   │  │ terraform   │  │ terraform   │  │terraform │ │
│  │    fmt      │→ │  validate   │→ │    plan     │→ │  apply   │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └──────────┘ │
└─────────────────────────────────────┬─────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                          AWS Infrastructure                      │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                    VPC (10.0.0.0/16)                   │   │
│  │                                                         │   │
│  │  ┌─────────────────┐         ┌─────────────────────┐   │   │
│  │  │  Public Subnet  │         │   Private Subnet    │   │   │
│  │  │                 │         │                     │   │   │
│  │  │ ┌─────────────┐ │   NAT   │                     │   │   │
│  │  │ │    EC2      │ │◄────────┤                     │   │   │
│  │  │ │   (Nginx)   │ │ Gateway │                     │   │   │
│  │  │ └─────────────┘ │         │                     │   │   │
│  │  └─────────────────┘         └─────────────────────┘   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              Remote State Management                    │   │
│  │  S3: terraform-state-x82zf9vy                          │   │
│  │  DynamoDB: terraform-state-lock                        │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

### Infrastructure Components
- **Compute**: EC2 instance (t3.small) running Nginx
- **Network**: VPC with public/private subnets, NAT Gateway
- **Security**: Security groups for web traffic and SSH
- **State**: Remote backend with S3 and DynamoDB

## 🚀 Quick Start

### Prerequisites
- **AWS Account** with sufficient permissions
- **GitHub Account** with Actions enabled
- **Git** >= 2.0

### 🔧 Deployment Options

#### Option 1: CI/CD Pipeline (Recommended)
1. **Fork/Clone Repository**
   ```bash
   git clone https://github.com/matthewntsiful/aws-terraform-nginx.git
   cd aws-terraform-nginx
   ```

2. **Configure GitHub Secrets**
   Navigate to Repository Settings → Secrets and Variables → Actions:
   ```
   AWS_ACCESS_KEY_ID: Your AWS Access Key
   AWS_SECRET_ACCESS_KEY: Your AWS Secret Key
   AWS_REGION: us-east-1
   ```

3. **Deploy via Pipeline**
   ```bash
   # Make any configuration changes
   git add .
   git commit -m "Deploy infrastructure"
   git push origin main
   ```

#### Option 2: Local Development
```bash
# Configure AWS credentials
aws configure

# Initialize and deploy
terraform init
terraform plan
terraform apply
```

**Note**: Both methods use the same S3 remote state for consistency.

## ⚙️ Configuration Management

### 🌍 Current Configuration
```hcl
# Default values in variables.tf
aws_region = "us-east-1"
environment = "dev"
instance_type = "t3.small"  # Recently upgraded from t3.micro
vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
availability_zones = ["us-east-1a", "us-east-1b"]
```

### 🗄️ Remote State Backend
```hcl
# Configured in provider.tf
backend "s3" {
  bucket         = "terraform-state-x82zf9vy"
  key            = "nginx-stack/terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "terraform-state-lock"
  encrypt        = true
}
```

## 🛠️ Operations

### 🚀 Making Changes
```bash
# Method 1: Via CI/CD Pipeline (Recommended)
git add .
git commit -m "Update infrastructure"
git push origin main
# → Triggers automatic deployment

# Method 2: Local Development
terraform plan    # Preview changes
terraform apply   # Apply changes
```

### 📊 Monitoring
```bash
# Check current infrastructure
terraform state list
terraform show

# View deployment history
# GitHub Actions → Workflow runs

# Access deployed application
terraform output
```

### 🔄 State Management
```bash
# State is automatically synchronized
# Both local and CI/CD use S3 remote state
# No manual state management required
```

## 📋 Pipeline Workflow Details

### 🔍 Continuous Integration
- **Code Quality**: Terraform format checking with `terraform fmt`
- **Syntax Validation**: Configuration validation with `terraform validate`
- **Security Scanning**: Infrastructure security analysis
- **Plan Generation**: Detailed change impact assessment

### 🚀 Continuous Deployment
- **Automated Deployment**: Push to main triggers deployment
- **State Synchronization**: Remote state ensures consistency
- **Change Tracking**: Complete audit trail of infrastructure changes

## 🏆 DevOps Best Practices Implemented

### ✅ Achieved
- **Infrastructure as Code**: All infrastructure defined in Terraform
- **Remote State Management**: S3 backend with DynamoDB locking
- **CI/CD Pipeline**: Automated validation and deployment
- **Security**: Encrypted state, secure networking, IAM best practices
- **Version Control**: Git-based infrastructure versioning
- **Environment Consistency**: Same state shared across environments

## 🔧 Troubleshooting

### ✅ Resolved Issues
- **Remote State**: Successfully configured with S3 backend
- **Pipeline Integration**: GitHub Actions workflow operational
- **State Synchronization**: Local and CI/CD environments synchronized

### 🔧 Common Operations
```bash
# Format code before committing
terraform fmt

# Validate configuration
terraform validate

# Check state synchronization
terraform state list

# View current outputs
terraform output
```

### 🚨 If Issues Occur
- **Pipeline Failures**: Check GitHub Actions logs
- **State Conflicts**: Ensure no concurrent operations
- **AWS Permissions**: Verify IAM policies for S3, EC2, VPC access

## 🤝 Contributing

### 📋 Development Workflow
1. **Fork Repository**: Create personal fork
2. **Feature Branch**: `git checkout -b feature/new-feature`
3. **Development**: Implement changes with validation
4. **Pull Request**: Submit PR with detailed description
5. **CI/CD Pipeline**: Automated testing and validation
6. **Merge**: Automatic deployment after approval

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 📞 Support & Contact

**Maintained by**: [Matthew Ntsiful](mailto:matthew.ntsiful@gmail.com)

- 🐛 **Issues**: [GitHub Issues](https://github.com/matthewntsiful/aws-terraform-nginx/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/matthewntsiful/aws-terraform-nginx/discussions)
- 📧 **Email**: matthew.ntsiful@gmail.com
- 💼 **LinkedIn**: [Matthew Ntsiful](https://linkedin.com/in/matthew-ntsiful)

---

⭐ **Star this repository if it helped you!**