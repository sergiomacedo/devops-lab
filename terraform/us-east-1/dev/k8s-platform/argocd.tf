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
      name  = "server.ingress.enabled"
      value = "true"
    },
    {
      name  = "server.ingress.ingressClassName"
      value = "traefik"
    },
    {
      name  = "server.ingress.hostname"
      value = "argocd.local"
    },
    # add an additional local user with apiKey capabilities.
    # Due to a bug in the helm chart renderization, we'll not use the `login` capability here, only the `apiKey`
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
    },
    # Assign the `admin` role as default.
    # MUST NOT BE DONE ON PRODUCION ENVIRONMENTS!
    {
      name  = "configs.rbac.policy\\.default"
      value = "role:admin"
    }
  ]
}
