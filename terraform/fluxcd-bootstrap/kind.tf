resource "kind_cluster" "fluxcd_setup" {
  name            = "fluxcd-setup"
  node_image      = "kindest/node:v1.35.0"
  kubeconfig_path = local.kind_kubeconfig_path
  kind_config {
    api_version = "kind.x-k8s.io/v1alpha4"
    kind        = "Cluster"
    node {
      role = "control-plane"
    }

  }
}
