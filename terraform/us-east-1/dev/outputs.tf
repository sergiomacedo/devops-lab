output "available_azs" {
  description = "List of available azs"
  value       = data.aws_availability_zones.aws_azs.names
}

output "vpc_id" {
  value       = module.vpc.vpc_id
}

output "eks_cluster_endpoint" {
  description = "EKS endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_ca_data" {
  description = "EKS CA data"
  value       = module.eks.cluster_certificate_authority_data
}

output "eks_cluster_name" {
  description = "EKS endpoint"
  value       = module.eks.cluster_name
}

output "eks_cluster_oidc_issuer" {
  description = "EKS endpoint"
  value       = module.eks.cluster_oidc_issuer_url
}

/*
output "controller_role_arn" {
  value = aws_iam_role.load_balancer_controller.arn
}

output "controller_policy_arn" {
  value = aws_iam_policy.load_balancer_controller.arn
}
*/
