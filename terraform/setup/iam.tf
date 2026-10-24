data "aws_caller_identity" "current" {}

variable "iam_user_name" {
  description = "IAM user allowed to assume the EKS administrator role"
  type        = string
  default     = "test"
}

resource "aws_iam_role" "eks_cluster_admin" {
  name = "EKSClusterAdmin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.iam_user_name}"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_admin" {
  role       = aws_iam_role.eks_cluster_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

