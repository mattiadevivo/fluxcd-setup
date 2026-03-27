resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}
# deploy keys are SSH keys that grant access to a single repository, they are not protected by passphrase
# this key will be used by Flux to fetch the git repository 
resource "github_repository_deploy_key" "flux_deploy_key" {
  title      = "FluxCD"
  repository = data.github_repository.fluxcd_setup.name
  key        = tls_private_key.flux.public_key_openssh
  read_only  = false
}

resource "flux_bootstrap_git" "this" {
  depends_on         = [github_repository_deploy_key.flux_deploy_key]
  embedded_manifests = true            # extract Flux manifests from the provider instead of GitHub.com
  path               = "clusters/kind" # path to which the cluster will be synced
}
