# Query aws for the number of availability zones
data "aws_availability_zones" "aws_azs" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>6.7"

  name = "Floci-lab"
  cidr = "10.0.0.0/16"
  azs  = data.aws_availability_zones.aws_azs.names

  private_subnets  = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]  # 4094 hosts / subnet
  public_subnets   = ["10.0.48.0/22", "10.0.52.0/22", "10.0.56.0/22"] # 1022 hosts / subnet. 10.0.60.0/22 is "lost"
  database_subnets = ["10.0.64.0/24", "10.0.65.0/24", "10.0.66.0/24"] #  254 hosts / subnet. 10.0.67.0/24 is "lost"

  enable_ipv6 = false

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = true

  # Creates a single exit point
  # CAVEAT: it may not be resilient to AZ or routing failures
  # PRO: Lower costs in real environments
  single_nat_gateway = true

  # Tags subnets for future EKS loadbalancer usage
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

