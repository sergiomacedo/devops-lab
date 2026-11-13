terraform {
  backend "s3" {
    bucket         = "my_company_terraform_states"
    key            = "us-east-1/dev/k8s-platform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_state"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>3.5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "eks-manager"
  region = data.aws_region.current.region
  assume_role {
    role_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/EKSClusterAdmin"
    session_name = "terraform-eks"
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.aws_resources.outputs.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.aws_resources.outputs.eks_ca_data)
  exec {
    api_version = "client.authentication.k8s.io/v1"
    args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.aws_resources.outputs.eks_cluster_name, "--region", data.aws_region.current.region, "--role-arn", "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/EKSClusterAdmin"]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes = {
    host                   = data.terraform_remote_state.aws_resources.outputs.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.aws_resources.outputs.eks_ca_data)
    exec = {
      api_version = "client.authentication.k8s.io/v1"
      args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.aws_resources.outputs.eks_cluster_name, "--region", data.aws_region.current.region, "--role-arn", "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/EKSClusterAdmin"]
      command     = "aws"
    }
  }
}

