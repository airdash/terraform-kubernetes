resource "helm_release" "externaldns" {
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  name             = "external-dns"
  namespace        = var.namespace
  version          = var.chart_version
  create_namespace = true
  cleanup_on_fail  = true

  values = [ file("${path.module}/values.yaml") ]
}

