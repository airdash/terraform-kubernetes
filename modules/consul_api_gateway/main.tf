resource "kubernetes_manifest" "gateway" {
  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1alpha2"
    "kind"       = "Gateway"

    "metadata" = {
      "annotations" = {
        "external-dns.alpha.kubernetes.io/hostname" = format("%s.%s", var.hostname, var.domain)
        "metallb.universe.tf/address-pool"          = var.metallb_address_pool
        "metallb.universe.tf/allow-shared-ip"       = var.name
      }

      "name"      = format("%s-%s", var.name, "gateway")
      "namespace" = var.namespace
    }

    "spec" = {
      "gatewayClassName" = format("%s-%s", var.name, "gateway-class")
      "listeners"        = var.listeners
    }
  }
}

resource "kubernetes_manifest" "gateway_class_config" {

  manifest = {
    "apiVersion" = "api-gateway.consul.hashicorp.com/v1alpha1"
    "kind"       = "GatewayClassConfig"

    metadata = {
      "name" = format("%s-%s", var.name, "gateway-class-config")
    }

    spec = {
      "image" = {
        "consulAPIGateway" = "hashicorp/consul-api-gateway:0.2.0"
        "envoy"            = "envoyproxy/envoy:v1.22.0"
      }
      "consul" = {
        "ports" = {
          "grpc" = 8502
          "http" = 8501
        }

        "scheme" = "https"
      }

      "copyAnnotations" = {
        "service" = ["external-dns.alpha.kubernetes.io/hostname", "metallb.universe.tf/address-pool", "metallb.universe.tf/allow-shared-ip"]
      }

      "logLevel"     = "debug"
      "serviceType"  = "LoadBalancer"
      "useHostPorts" = false
    }
  }
}

resource "kubernetes_manifest" "gateway_class" {

  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1alpha2"
    "kind"       = "GatewayClass"

    metadata = {
      "name" = format("%s-%s", var.name, "gateway-class")
    }

    spec = {
      "controllerName" = "hashicorp.com/consul-api-gateway-controller"

      "parametersRef" = {
        "group" = "api-gateway.consul.hashicorp.com"
        "kind"  = "GatewayClassConfig"
        "name"  = format("%s-%s", var.name, "gateway-class-config")
      }
    }
  }
}

