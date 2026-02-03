terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.2"
    }
  }

  required_version = ">= 1.13.2"
  backend "s3" {
    bucket       = "caprover-state-bucket"
    key          = "infra/terraform.tfstate"
    region       = "ap-southeast-5"
    encrypt      = true
    use_lockfile = true
  }

}

provider "aws" {
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::REDACTED_AWS_ACCOUNT_ID:role/Terraform-Role"
    session_name = "Terraform-Bootstrap-Session"
  }
}