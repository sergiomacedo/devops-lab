

locals {
  oidc_issuer = module.eks.cluster_oidc_issuer_url

  oidc_provider = trimprefix(
    local.oidc_issuer,
    "https://"
  )
}

# Register the cluster OIDC provider in IAM
data "aws_iam_openid_connect_provider" "oidc" {
  url = local.oidc_issuer
}

# AWS Load Balancer Controller IAM policy
resource "aws_iam_policy" "aws_load_balancer_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Permissions for AWS Load Balancer Controller"

  policy = file("${path.module}/albc-policy/iam_policy.json")
}

# IAM role
resource "aws_iam_role" "aws_load_balancer_controller" {
  name = "k3s-aws-load-balancer-controller"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Federated = data.aws_iam_openid_connect_provider.oidc.arn
      }

      Action = "sts:AssumeRoleWithWebIdentity"

      Condition = {
        StringEquals = {
          "${local.oidc_provider}:aud" = "sts.amazonaws.com"

          "${local.oidc_provider}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

# Attach permissions
resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {
  role = aws_iam_role.aws_load_balancer_controller.name

  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}

