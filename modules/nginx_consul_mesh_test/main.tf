resource "kubernetes_deployment" "nginx_deployment" {
  count = 1

  depends_on = [kubernetes_service.nginx_service, kubernetes_service_account.nginx_service_account]

  metadata {
    name = var.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app     = var.name
      }
    }

    template {
      metadata {
        labels = {
          app     = var.name
          version = "v1"
        }
        annotations = {
          "consul.hashicorp.com/connect-inject"                     = "true"
          "consul.hashicorp.com/transparent-proxy"                  = "true"
          "consul.hashicorp.com/transparent-proxy-overwrite-probes" = "true"
        }
      }

      spec {
        container {
          image = "nginx"
          name  = var.name

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }

          port {
            container_port = 80
            name           = "http"
          }
        }
        service_account_name = var.name
      }
    }
  }
}

resource "kubernetes_service" "nginx_service" {

  metadata {
    name = var.name
    annotations = {
      "consul.hashicorp.com/service-name" = var.name
    }
  }

  spec {
    selector = {
      app     = var.name
    }

    # session_affinity = "ClientIP"

    port {
      port        = 80
      target_port = 80
    }
    # type = "LoadBalancer"
  }
}

resource "kubernetes_service_account" "nginx_service_account" {
  metadata {
    name = var.name
  }
}

module "consul_service" {
  source = "../../modules/consul_service"
  service_name = var.name
}

module "consul_api_gateway" {
  source = "../../modules/consul_api_gateway"

  domain = var.domain
  hostname = var.name
  metallb_address_pool = "external-pool"
  service_name = var.name

  http_listeners = [{
    hostname = format("%s.%s", var.name, var.domain)
    port = "80"
  }]
}
