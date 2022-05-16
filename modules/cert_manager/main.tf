resource "helm_release" "cert_manager" {
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  name             = "cert-manager"
  namespace        = var.namespace
  version          = var.chart_version
  create_namespace = true
  cleanup_on_fail  = true

  values = [ file("${path.module}/values.yaml") ]
}

