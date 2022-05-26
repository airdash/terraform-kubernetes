locals {
  name   = length(var.name) > 0 ? var.name : "ingress-nginx"
  values = var.is_consul_gateway ? file("${path.module}/consul-values.yaml") : {}
}

resource "helm_release" "nginx_ingress_controller" {
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  name             = local.name
  namespace        = var.namespace
  version          = var.chart_version
  create_namespace = true
  cleanup_on_fail  = true

  values = local.values
}
