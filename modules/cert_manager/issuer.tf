resource "kubernetes_manifest" "cert-manager-r53-issuer" {
  count = 1
  depends_on = [ helm_release.cert_manager ]
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    
    "metadata" = {
      "name" = "letsencrypt"
    }

    "spec" = {
      "acme" = {
        "email" = "admin@sour.ninja"
        "server" = "https://acme-staging-v02.api.letsencrypt.org/directory"

        "privateKeySecretRef" = {
          name = "cm-r53-secret-key"
        }

        "solvers" = [{
          "dns01" = {
            "route53" = {
              "accessKeyID" = "AKIA3TOJAXMR57CJZB3F"
              "region" = "us-east-1"
              "secretAccessKeySecretRef" = {
                "key" = "secret-access-key"
                "name" = "cert-manager-r53-secret"
              }
            }
          },
          "selector" = {
            "dnsZones" = [ "sour.ninja" ]
          }
        }]
      }
    }
  }
}
