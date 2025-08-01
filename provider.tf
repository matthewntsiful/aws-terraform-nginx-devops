terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "matthew-terraform-terraform-state-zxwoeb1w"
    key            = "nginx-stack/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "matthew-terraform-terraform-state-lock"
    encrypt        = true
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