resource "helm_release" "grafana" {
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  name             = "grafana"
  namespace        = var.namespace
  version          = var.chart_version
  create_namespace = true
  cleanup_on_fail  = true

  values = [ file("${path.module}/values.yaml") ]
}

