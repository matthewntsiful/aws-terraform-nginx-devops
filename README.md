# AWS Terraform Nginx DevOps Stack

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![EC2](https://img.shields.io/badge/Amazon_EC2-FF9900?style=for-the-badge&logo=amazonec2&logoColor=white)
![VPC](https://img.shields.io/badge/Amazon_VPC-FF9900?style=for-the-badge&logo=amazonvpc&logoColor=white)
![CloudWatch](https://img.shields.io/badge/Amazon_CloudWatch-FF4F8B?style=for-the-badge&logo=amazoncloudwatch&logoColor=white)
![IAM](https://img.shields.io/badge/AWS_IAM-FF9900?style=for-the-badge&logo=amazoniam&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![YAML](https://img.shields.io/badge/YAML-CB171E?style=for-the-badge&logo=yaml&logoColor=white)
![HCL](https://img.shields.io/badge/HCL-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![CI/CD](https://img.shields.io/badge/CI%2FCD-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)
![DevOps](https://img.shields.io/badge/DevOps-326CE5?style=for-the-badge&logo=devops&logoColor=white)
![IaC](https://img.shields.io/badge/Infrastructure_as_Code-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Security](https://img.shields.io/badge/Security-FF6B6B?style=for-the-badge&logo=security&logoColor=white)
![Monitoring](https://img.shields.io/badge/Monitoring-FF4F8B?style=for-the-badge&logo=datadog&logoColor=white)
![Automation](https://img.shields.io/badge/Automation-4CAF50?style=for-the-badge&logo=automation&logoColor=white)

## 🚀 DevOps Infrastructure Stack

Production-ready AWS infrastructure demonstrating modern DevOps practices with Infrastructure as Code (IaC), automated CI/CD pipelines, security best practices, and comprehensive monitoring solutions.

## ✨ DevOps Features

### 🏗️ Infrastructure as Code (IaC)
- **Terraform**: Declarative infrastructure provisioning with state management
- **Modular Design**: Reusable, maintainable code structure with variable configurations
- **Remote State**: S3 backend with DynamoDB locking for team collaboration
- **Environment Separation**: Multi-environment support (dev/staging/prod)
- **Version Control**: Git-based infrastructure versioning and change tracking
- **Drift Detection**: Automated infrastructure drift monitoring and alerts

### 🔄 CI/CD Pipeline
- **Automated Testing**: Terraform format validation, syntax checking, and security scanning
- **Plan Generation**: Infrastructure change previews with cost estimation
- **Approval Gates**: Manual approval workflows for production deployments
- **Artifact Management**: Secure plan storage and retrieval with versioning
- **Branch Protection**: Main branch deployment controls with required reviews
- **Rollback Strategy**: Automated rollback capabilities with state restoration
- **Multi-Environment**: Automated promotion through dev → staging → prod

### 🔒 Security & Compliance
- **Least Privilege**: IAM roles with minimal required permissions
- **Secret Management**: AWS Secrets Manager and GitHub encrypted secrets
- **Network Segmentation**: VPC with public/private subnet isolation
- **Security Groups**: Granular traffic controls with principle of least access
- **Encryption**: Data encryption at rest and in transit
- **Compliance**: SOC2, PCI-DSS ready configurations
- **Vulnerability Scanning**: Automated security assessments

### 📊 Monitoring & Observability
- **Infrastructure Monitoring**: AWS CloudWatch with custom metrics and dashboards
- **Application Performance**: Real-time performance monitoring and alerting
- **Log Aggregation**: Centralized logging with CloudWatch Logs
- **Deployment Tracking**: Complete pipeline execution audit trails
- **Change Auditing**: Terraform state change tracking and notifications
- **Cost Monitoring**: AWS Cost Explorer integration with budget alerts
- **Health Checks**: Automated endpoint monitoring and failover

### 🛠️ Operational Excellence
- **Disaster Recovery**: Multi-AZ deployment with automated backup strategies
- **High Availability**: Load balancing with auto-scaling capabilities
- **Performance Optimization**: Resource right-sizing and cost optimization
- **Documentation**: Auto-generated infrastructure documentation
- **Runbooks**: Standardized operational procedures and troubleshooting guides

## 🏛️ Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                          GitHub Repository                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │
│  │   Format    │  │  Validate   │  │   Security  │  │    Plan     │ │
│  │   Check     │  │   Syntax    │  │    Scan     │  │  Generate   │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘ │
│                                    │                                │
│                            ┌─────────────┐                         │
│                            │   Manual    │                         │
│                            │  Approval   │                         │
│                            └─────────────┘                         │
│                                    │                                │
│                            ┌─────────────┐                         │
│                            │    Apply    │                         │
│                            │  & Deploy   │                         │
│                            └─────────────┘                         │
└─────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────┐
│                            AWS Cloud                                │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                         VPC (10.0.0.0/16)                  │   │
│  │                                                             │   │
│  │  ┌─────────────────┐              ┌─────────────────────┐   │   │
│  │  │  Public Subnet  │              │   Private Subnet    │   │   │
│  │  │  (10.0.1.0/24)  │              │   (10.0.101.0/24)   │   │   │
│  │  │                 │              │                     │   │   │
│  │  │ ┌─────────────┐ │    NAT       │ ┌─────────────────┐ │   │   │
│  │  │ │    EC2      │ │ ◄────────────┤ │   Future        │ │   │   │
│  │  │ │   (Nginx)   │ │   Gateway    │ │   Resources     │ │   │   │
│  │  │ │             │ │              │ │                 │ │   │   │
│  │  │ └─────────────┘ │              │ └─────────────────┘ │   │   │
│  │  │                 │              │                     │   │   │
│  │  │ ┌─────────────┐ │              │                     │   │   │
│  │  │ │   ALB       │ │              │                     │   │   │
│  │  │ │ (Optional)  │ │              │                     │   │   │
│  │  │ └─────────────┘ │              │                     │   │   │
│  │  └─────────────────┘              └─────────────────────┘   │   │
│  │                                                             │   │
│  │  ┌─────────────────────────────────────────────────────┐   │   │
│  │  │                Security Groups                      │   │   │
│  │  │  • Web: HTTP(80), HTTPS(443)                       │   │   │
│  │  │  • SSH: Port 22 (restricted IPs)                   │   │   │
│  │  │  • Database: Port 3306/5432 (internal only)        │   │   │
│  │  └─────────────────────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    Monitoring & Logging                     │   │
│  │  • CloudWatch Metrics & Dashboards                         │   │
│  │  • CloudWatch Logs for Application & System Logs          │   │
│  │  • CloudTrail for API Audit Logging                       │   │
│  │  • AWS Config for Compliance Monitoring                   │   │
│  └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

## 🚀 Quick Start

### Prerequisites
- **Terraform** >= 1.7.5
- **AWS CLI** >= 2.0 (configured with appropriate credentials)
- **Git** >= 2.0
- **GitHub Account** with Actions enabled
- **AWS Account** with sufficient permissions for EC2, VPC, IAM

### 🔧 Local Development Setup

1. **Clone Repository**
   ```bash
   git clone https://github.com/matthewntsiful/aws-terraform-nginx.git
   cd aws-terraform-nginx
   ```

2. **Configure AWS Credentials**
   ```bash
   aws configure
   # OR use environment variables
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   export AWS_DEFAULT_REGION="us-east-1"
   ```

3. **Create Terraform Variables**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
   
   Edit `terraform.tfvars`:
   ```hcl
   aws_region = "us-east-1"
   environment = "dev"
   instance_type = "t3.micro"
   public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
   private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
   allowed_ssh_cidrs = ["YOUR_IP/32"]
   ```

4. **Initialize and Deploy**
   ```bash
   terraform init
   terraform validate
   terraform plan
   terraform apply
   ```

### 🔄 CI/CD Pipeline Setup

1. **GitHub Secrets Configuration**
   Navigate to Repository Settings → Secrets and Variables → Actions:
   ```
   AWS_ACCESS_KEY_ID: Your AWS Access Key
   AWS_SECRET_ACCESS_KEY: Your AWS Secret Key
   AWS_REGION: Your preferred AWS region (e.g., us-east-1)
   ```

2. **Pipeline Triggers**
   - **Push to main**: Triggers validation and planning
   - **Pull Request**: Runs full validation suite
   - **Manual Dispatch**: Allows manual deployment approval
   - **Scheduled**: Weekly infrastructure drift detection

3. **Deployment Workflow**
   ```
   Feature Branch → PR → Validation → Review → Merge → Deploy
   ```

## 📋 Pipeline Workflow Details

### 🔍 Continuous Integration
- **Code Quality**: Terraform format checking with `terraform fmt`
- **Syntax Validation**: Configuration validation with `terraform validate`
- **Security Scanning**: Infrastructure security analysis with tfsec/checkov
- **Plan Generation**: Detailed change impact assessment
- **Cost Estimation**: Infrastructure cost analysis and budgeting
- **Compliance Checks**: Policy validation against organizational standards

### 🚀 Continuous Deployment
- **Approval Gates**: Manual review process for production changes
- **Blue-Green Deployment**: Zero-downtime deployment strategies
- **Rollback Capability**: Automated rollback with state restoration
- **Environment Promotion**: Staged deployment across environments
- **Health Checks**: Post-deployment validation and monitoring
- **Notification System**: Slack/Teams integration for deployment status

## 🏆 DevOps Best Practices Implemented

### 📝 Version Control & GitOps
- **Infrastructure as Code**: All infrastructure defined in version control
- **Branch Protection**: Enforced code reviews and status checks
- **Semantic Versioning**: Tagged releases with changelog generation
- **Git Hooks**: Pre-commit validation and formatting
- **Change Documentation**: Automated change log generation

### 🧪 Testing Strategy
- **Unit Tests**: Terraform module testing with Terratest
- **Integration Tests**: End-to-end infrastructure validation
- **Security Tests**: Automated vulnerability scanning
- **Performance Tests**: Load testing and capacity planning
- **Chaos Engineering**: Fault injection and resilience testing

### 🔐 Security Implementation
- **Zero Trust Architecture**: Network segmentation and micro-segmentation
- **Encryption Everywhere**: Data encryption at rest and in transit
- **Identity Management**: Centralized IAM with role-based access
- **Secrets Rotation**: Automated credential rotation and management
- **Audit Logging**: Comprehensive audit trails and compliance reporting
- **Vulnerability Management**: Continuous security scanning and patching

### 📊 Monitoring & Alerting
- **Infrastructure Metrics**: CPU, memory, disk, network monitoring
- **Application Metrics**: Custom business metrics and KPIs
- **Log Analysis**: Centralized logging with search and analytics
- **Alerting Rules**: Intelligent alerting with escalation policies
- **Dashboards**: Real-time operational dashboards
- **SLA Monitoring**: Service level agreement tracking and reporting

## ⚙️ Configuration Management

### 🌍 Environment Variables
```hcl
# terraform.tfvars
aws_region = "us-east-1"
environment = "production"
instance_type = "t3.micro"
vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
enable_nat_gateway = true
enable_vpn_gateway = false
enable_dns_hostnames = true
enable_dns_support = true
```

### 🔧 Pipeline Configuration
```yaml
# .github/workflows/web-stack.yaml
env:
  TF_VERSION: '1.7.5'
  AWS_DEFAULT_REGION: 'us-east-1'
  TF_IN_AUTOMATION: 'true'
```

### 📦 Module Configuration
```hcl
# modules/networking/variables.tf
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
```

## 🛠️ Operations Guide

### 🚀 Deployment Operations
```bash
# Manual deployment with plan review
terraform plan -out=tfplan
terraform apply tfplan

# Environment-specific deployment
terraform workspace select production
terraform apply -var-file="environments/prod.tfvars"

# Targeted resource deployment
terraform apply -target=module.networking
```

### 📊 Monitoring Operations
```bash
# Infrastructure status check
terraform show
terraform state list

# Resource inspection
terraform state show aws_instance.web_server
aws ec2 describe-instances --instance-ids i-1234567890abcdef0

# Log monitoring
aws logs tail /aws/ec2/nginx --follow
```

### 🔄 Rollback Procedures
```bash
# Emergency rollback
terraform plan -destroy
terraform destroy -target=aws_instance.web_server

# State restoration
terraform state pull > backup.tfstate
terraform state push backup.tfstate

# Version rollback
git checkout v1.2.3
terraform init
terraform apply
```

## 🔧 Troubleshooting Guide

### ⚠️ Common Issues

#### Permission Errors
```bash
# Verify AWS credentials
aws sts get-caller-identity

# Check IAM permissions
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::123456789012:user/username \
  --action-names ec2:RunInstances \
  --resource-arns "*"
```

#### State Lock Issues
```bash
# Force unlock (use with caution)
terraform force-unlock LOCK_ID

# Check DynamoDB lock table
aws dynamodb scan --table-name terraform-state-lock
```

#### Resource Conflicts
```bash
# Import existing resources
terraform import aws_instance.web_server i-1234567890abcdef0

# Remove from state without destroying
terraform state rm aws_instance.web_server
```

### 🚨 Pipeline Failures

#### GitHub Actions Debugging
```yaml
# Enable debug logging
- name: Debug Terraform
  run: |
    export TF_LOG=DEBUG
    terraform plan
```

#### Secret Validation
```bash
# Test AWS credentials in Actions
- name: Validate AWS Credentials
  run: aws sts get-caller-identity
```

## 📈 Performance Optimization

### 💰 Cost Optimization
- **Right-sizing**: Automated instance type recommendations
- **Reserved Instances**: Cost analysis and RI purchasing recommendations
- **Spot Instances**: Integration for non-critical workloads
- **Resource Scheduling**: Automated start/stop for development environments

### ⚡ Performance Tuning
- **Auto Scaling**: Dynamic scaling based on metrics
- **Load Balancing**: Traffic distribution and health checks
- **Caching**: CloudFront CDN integration
- **Database Optimization**: RDS performance insights and tuning

## 🤝 Contributing

### 📋 Development Workflow
1. **Fork Repository**: Create personal fork
2. **Feature Branch**: `git checkout -b feature/new-feature`
3. **Development**: Implement changes with tests
4. **Validation**: Run local validation suite
5. **Pull Request**: Submit PR with detailed description
6. **Code Review**: Peer review and approval
7. **CI/CD Pipeline**: Automated testing and validation
8. **Merge**: Merge to main branch after approval

### 📝 Code Standards
- **Terraform**: Follow HashiCorp style guide
- **Documentation**: Update README and inline comments
- **Testing**: Include unit and integration tests
- **Security**: Security scanning and compliance checks

### 🔍 Review Checklist
- [ ] Code follows style guidelines
- [ ] Tests pass locally and in CI
- [ ] Documentation updated
- [ ] Security scan passes
- [ ] Performance impact assessed
- [ ] Backward compatibility maintained

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