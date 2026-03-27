terraform {
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "1.8.3"
    }
    kind = {
      source  = "tehcyx/kind"
      version = "0.11.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.11.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.2.1"
    }
  }
}

provider "flux" {
  kubernetes = {
    host                   = kind_cluster.fluxcd_setup.endpoint
    client_certificate     = kind_cluster.fluxcd_setup.client_certificate
    client_key             = kind_cluster.fluxcd_setup.client_key
    cluster_ca_certificate = kind_cluster.fluxcd_setup.cluster_ca_certificate
  }
  git = {
    url = "ssh://git@github.com/${data.github_repository.fluxcd_setup.full_name}.git"
    ssh = {
      username    = "git"
      private_key = tls_private_key.flux.private_key_pem
    }
  }
}

provider "github" {
  token = var.github_token
}

provider "kind" {}

