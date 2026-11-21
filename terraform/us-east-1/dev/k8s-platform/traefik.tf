# # 1) Generate a self‑signed certificate valid for *.docker.localhost
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
#   -keyout tls.key -out tls.crt \
#   -subj "/CN=*.local"

# # 2) Create the TLS secret in the traefik namespace
# kubectl create secret tls local-selfsigned-tls \
#   --cert=tls.crt --key=tls.key \
#   --namespace traefik


resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = "42.4.1"
  # version    = "27.0.2"

  # Default values
  # https://github.com/argoproj/argo-helm/blob/main/charts/argo-cd/values.yaml

  namespace        = "traefik"
  create_namespace = true

  set = [
    # Do not enable this in production unless accepting unverified certificates is intentional.
    { name   = "additionalArguments[0]"
      value  = "--serversTransport.insecureSkipVerify=true"
    },
    {
      name  = "ingressClass.name"
      value = "traefik"
    },
    {
      name = "providers.kubernetesCRD.ingressClass"
      value = "traefik"
    },
    {
      name = "providers.kubernetesIngress.ingressClass"
      value = "traefik"
    },
    {
      name = "providers.kubernetesIngressNGINX.enabled"
      value = "true"
    },
    {
      name  = "providers.kubernetesCRD.safeNaming"
      value = "true"
    },
    {
      name  = "log.level"
      value = "INFO"  # Use DEBUG for more verbose logging
    },
    {
      name = "accessLog.enabled"
      value = "true"
    },

  ]
}
