data "terraform_remote_state" "aws_resources" {
  backend = "s3"
  config = {
    bucket = "my_company_terraform_states"
    key    = "us-east-1/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

