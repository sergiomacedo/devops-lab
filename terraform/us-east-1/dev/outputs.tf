output "available_azs" {
  description = "List of available azs"
  value       = data.aws_availability_zones.aws_azs.names
}

output "vpc" {
  description = "List of available azs"
  value       = module.vpc.vpc_id
}

/*
output "controller_role_arn" {
  value = aws_iam_role.load_balancer_controller.arn
}

output "controller_policy_arn" {
  value = aws_iam_policy.load_balancer_controller.arn
}
*/
