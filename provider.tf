terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  alias  = "main"

  default_tags {
    tags = {
      Environment = "dev"
      Project     = "matthew"
      ManagedBy   = "terraform"
    }
  }
}
provider "aws" {
  region = var.aws_region
}