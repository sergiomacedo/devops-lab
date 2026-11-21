# Helm application
resource "argocd_application" "sample-nginx-dev" {
  metadata {
    name      = "sample-nginx-dev"
    namespace = "argocd"
    labels = {
      test = "true"
    }
  }

  spec {
    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }
    }

    source {
      repo_url        = "https://github.com/sergiomacedo/devops-lab.git"
      path            = "apps/sample/chart"
      target_revision = "HEAD"
      helm {
        # value_files = ["$values/apps/sample/dev/values.yaml"]
        value_files = ["../dev/values.yaml"]
      }
    }
    
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "default"
    }
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
    ]
  }
}
