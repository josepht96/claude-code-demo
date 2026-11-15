terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Partial config; values live in backend.hcl:
  #   terraform init -backend-config=backend.hcl
  backend "s3" {}
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile

  # Refuse to run against any account not listed (when set), so a stray
  # AWS_PROFILE can't apply this env to the wrong account.
  allowed_account_ids = length(var.allowed_account_ids) > 0 ? var.allowed_account_ids : null

  default_tags {
    tags = {
      Project     = var.project
      Environment = local.env
      ManagedBy   = "terraform"
    }
  }
}
