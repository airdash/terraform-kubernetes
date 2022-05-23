locals {
  # Assume - perhaps improperly - that if gateway isn't defined then it's not shared and is generated.
  # We could also ostensibly use a different gateway for http/https/tcp/etc, but why?
  #
  gateway = length(var.gateway) > 0 ? var.gateway : format("%s-%s", var.service_name, "gateway")
}

resource "kubernetes_manifest" "http_route" {
  count = local.http_gateway_enabled

  manifest = {

    "apiVersion" = "gateway.networking.k8s.io/v1alpha2"
    "kind"       = "HTTPRoute"

    metadata = {
      "name"      = format("%s-http-%s", var.service_name, "route")
      "namespace" = var.namespace
    }

    spec = {
      "parentRefs" = [{
        "name"      = local.gateway
      }]
      "rules" = var.backendRefs
    }
  }
}

resource "kubernetes_manifest" "reference_policy" {

  manifest = {

    "apiVersion" = "gateway.networking.k8s.io/v1alpha2"
    "kind"       = "ReferencePolicy"

    metadata = {
      "name"      = format("%s-%s", var.service_name, "reference-policy")
      "namespace" = var.namespace
    }

    spec = {
      "from" = [{
        "group"     = "gateway.networking.k8s.io"
        "kind"      = "HTTPRoute"
        "namespace" = var.namespace
      }]

      "to" = [{
        "group" = ""
        "kind"  = "Service"
        "name"  = var.service_name
      }]
    }
  }
}
