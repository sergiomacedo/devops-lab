terraform {
  backend "s3" {
    bucket         = "my_company_terraform_states"
    key            = "us-east-1/dev/argocd-applications/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_state"
    encrypt        = true
  }
  required_providers {
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "~>7.18.0"
    }
  }
}


provider "argocd" {
  server_addr = "argocd.local"
  insecure    = true
  username    = "devops-lab"
  auth_token  = "<READ THE INSTRUCTIONS>"
}
