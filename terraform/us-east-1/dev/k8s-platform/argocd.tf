resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "10.18.0"

  # Default values
  # https://github.com/argoproj/argo-helm/blob/main/charts/argo-cd/values.yaml

  namespace        = "argocd"
  create_namespace = true

  set = [
    {
      name  = "server.service.type"
      value = "LoadBalancer"
    },
    # add an additional local user with apiKey capabilities.
    # Due to a bug in the helm chart renderization, we'll not use the `login` capability, only the `apiKey`
    #   apiKey - allows generating API keys
    #
    {
      name  = "configs.cm.accounts\\.devops-lab"
      value = "apiKey"
    },
    # Users are enabled by default, but we're making it clear here
    {
      name  = "configs.cm.accounts\\.devops-lab\\.enabled"
      value = "true"
    }
  ]
}
