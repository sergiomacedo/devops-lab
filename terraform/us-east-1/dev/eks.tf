locals {
  cluster_name = "devops-lab"
}

module "eks" {

  providers = {
    aws = aws.eks-manager
  }

  source             = "terraform-aws-modules/eks/aws"
  version            = "~>20"
  name               = local.cluster_name
  kubernetes_version = "1.34"
  ip_family          = "ipv4"
  subnet_ids         = module.vpc.private_subnets

  # When using a real EKS cluster, this MUST be set to STANDARD or you'll pay A LOT for unnecessary extended support
  # upgrade_policy = {
  #   support_type = "STANDARD" # "STANDARD" or "EXTENDED"
  # }


  # Create default access role for the user creating cluster
  # Running locally,it will be the operator's user
  # In a CI/CD configuration, it will be the automation's user
  # TODO: Add custom aws-auth/roles

  # Do not create the role for floci environment
  enable_cluster_creator_admin_permissions = false

  # Add logs. Extremely useful for debugging "fat fingers"
  enabled_log_types = [
    "audit",
  ]


  # Ideally cluster access must be made via VPN/internal network only
  endpoint_public_access  = false
  endpoint_private_access = true

  vpc_id = module.vpc.vpc_id

  # When using floci, the k3s backend already comes with the expected addons
  # Enable them if you're using a real EKS cluster
  /*
  addons = {
    coredns = {
      resolve_conflicts_on_update = "OVERWRITE"
    }
    kube-proxy = {
      resolve_conflicts_on_update = "OVERWRITE"
    }
    vpc-cni = {
      resolve_conflicts_on_update = "OVERWRITE"

      # Reduces IP consumption but may delay creation of new pods
      configuration_values = jsonencode({
        env = {
          WARM_IP_TARGET  = "5"
          WARM_ENI_TARGET = "1"
        }
      })
    }
  }
*/

  node_security_group_additional_rules = {
    node_to_node_all = {
      description      = "node to nodes"
      protocol         = "-1"
      from_port        = 0
      to_port          = 65534
      type             = "ingress"
      cidr_blocks      = module.vpc.private_subnets_cidr_blocks
      ipv6_cidr_blocks = null
    }
  }

  /*
  eks_managed_node_groups = {
    default = {
      # No gpu support on this lab
      enable_efa_support = false
      subnet_ids         = module.vpc.private_subnets
      #ami_type       = "AL2023_x86_64" 
      ami_type       = "CUSTOM"
user_data_template_path = "path/to/your/custom_user_data.tpl"
      disk_size          = 50

      # Allow use of Session Manager to access nodes

      #      iam_role_additional_policies = {
      #        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      #      }
      tags = {
        "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned"
        "k8s.io/cluster-autoscaler/enabled"               = true
      }
      desired_size = 1
      max_size     = 2

      # Please, keep something running!!!
      min_size       = 1
      instance_types = ["t4a.medium"]
    }
  }
  depends_on = [
    aws_iam_role.eks_cluster_admin
  ]
*/
}
