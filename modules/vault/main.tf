resource "helm_release" "vault" {
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault"
  name             = "vault"
  namespace        = var.namespace
  version          = var.chart_version
  create_namespace = true
  cleanup_on_fail  = true

  values = [file("${path.module}/values.yaml")]
}
