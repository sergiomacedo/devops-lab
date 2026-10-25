terraform {
  backend "s3" {
    bucket         = "my_company_terraform_states"
    key            = "us-east-1/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_state"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "eks-manager"
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::111111111111:role/EKSClusterAdmin"
    session_name = "terraform-eks"
  }
}

