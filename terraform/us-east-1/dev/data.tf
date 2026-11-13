
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# Query aws for the number of availability zones
data "aws_availability_zones" "aws_azs" {
  state = "available"
}


data "aws_vpc" "default_vpc" {
  default = "true"
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

data "aws_subnet" "default_subnet_list" {
  for_each = toset(data.aws_subnets.default_subnets.ids)
  id       = each.value
}
