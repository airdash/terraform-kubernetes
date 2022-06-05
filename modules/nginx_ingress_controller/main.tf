locals {
  name   = length(var.name) > 0 ? var.name : "ingress-nginx"
  values = var.is_consul_gateway ? [local.consul_values] : [local.default_values]
  default_values = yamlencode({
    "controller" = {
      "ingressClassByName" = "true"
      "ingressClassResource" = {
        "name"    = local.name
        "enabled" = "true"
        "default" = "false"
      }
    }
  })

  consul_values = yamlencode({
    "controller" = {
      "admissionWebhooks" = {
        "service" = {
          "annotations" = {
            "consul.hashicorp.com/service-ignore" = "true"
          }
        }
      }

      "ingressClassByName" = "true"

      "ingressClassResource" = {
        "name"    = local.name
        "enabled" = "true"
        "default" = "false"
      }

      "podAnnotations" = {
        "consul.hashicorp.com/connect-inject"                           = "true"
        "consul.hashicorp.com/transparent-proxy"                        = "true"
        "consul.hashicorp.com/transparent-proxy-exclude-inbound-ports"  = "8000,80,443,9000,8443"
        "consul.hashicorp.com/transparent-proxy-exclude-outbound-cidrs" = "10.96.0.1/32"
      }
    }
  })
}

resource "helm_release" "nginx_ingress_controller" {
  count            = 1
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  name             = local.name
  namespace        = var.namespace
  version          = var.chart_version
  create_namespace = true
  cleanup_on_fail  = true

  values = local.values
}
