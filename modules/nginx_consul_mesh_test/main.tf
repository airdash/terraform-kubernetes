locals {
  use_nginx_ingress = var.use_nginx_ingress ? 1 : 0
}

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
        app = var.name
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
      app = var.name
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

resource "kubernetes_ingress_v1" "nginx_ingress" {
  count = local.use_nginx_ingress

  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
      "external-dns.alpha.kubernetes.io/hostname"  = format("%s.%s", var.name, "sour.ninja")
      "cert-manager.io/cluster-issuer"             = "letsencrypt-staging"
    }
    name = format("%s-%s", var.name, "ingress")
  }

  spec {
    ingress_class_name = var.nginx_ingress_class
    tls {
      hosts       = [format("%s.%s", var.name, "sour.ninja")]
      secret_name = format("%s-%s", var.name, "tls")
    }
    rule {
      host = format("%s.%s", var.name, "sour.ninja")
      http {
        path {
          path = "/"
          backend {
            service {
              name = var.name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

module "consul_service" {
  source          = "../../modules/consul_service"
  service_name    = var.name
  dialed_directly = true
}

