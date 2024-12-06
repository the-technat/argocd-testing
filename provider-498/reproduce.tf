terraform {
  required_providers {
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.0.3"
    }
  }
}

provider "argocd" {
  username = "admin"
  password = "acceptancetesting"
  kubernetes {
    config_context = "kind-argocd"
  }
}