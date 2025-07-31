/*
AWS Region
- The AWS region where resources will be created
- Defaults to af-south-1 (Cape Town)
- Can be overridden via environment variable TF_VAR_aws_region
*/
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"  # Changed to us-east-1
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]  # Using us-east-1 AZs
}



/*
VPC CIDR Block
- The primary CIDR block for the VPC
- Should be a /16 network (65,536 IPs)
- Must not overlap with other networks in your infrastructure
*/
variable "vpc_cidr" {
  description = "Primary CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.vpc_cidr))
    error_message = "Must be a valid CIDR block (e.g., 10.0.0.0/16)"
  }
}

/*
Public Subnet CIDR Blocks
- List of CIDR blocks for public subnets
- Should be within the VPC CIDR
- Each should be a /24 subnet (256 IPs)
*/
variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) >= 1
    error_message = "At least one public subnet is required"
  }
}

/*
Private Subnet CIDR Blocks
- List of CIDR blocks for private subnets
- Should be within the VPC CIDR
- Each should be a /24 subnet (256 IPs)
*/
variable "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]

  validation {
    condition     = length(var.private_subnet_cidrs) >= 1
    error_message = "At least one private subnet is required"
  }
}

/*
EC2 Instance Type
- The instance type for the web server
- Should be appropriate for your workload
- Default is t3.micro (free tier eligible)
*/
variable "instance_type" {
  description = "EC2 instance type for the web server"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^[a-z0-9]+\\.\\w+$", var.instance_type))
    error_message = "Must be a valid AWS instance type (e.g., t3.micro)"
  }
}

/*
Environment Tag
- Used to tag resources with the environment name
- Helps with cost allocation and resource management
*/
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod"
  }
}