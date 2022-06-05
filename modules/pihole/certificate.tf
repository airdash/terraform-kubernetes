resource "kubernetes_manifest" "pihole_certificate" {
  count = 0
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"

    "metadata" = {
      "name"      = "pihole-certificate"
      "namespace" = "pihole"
    }

    "spec" = {
      "secretName"  = "pihole-certificate"
      "duration"    = "8760h"
      "renewBefore" = "360h"
      "subject" = {
        "organizations" = ["sour.ninja"]
      }
      "isCA" = "false"
      "privateKey" = {
        "algorithm" = "RSA"
        "encoding"  = "PKCS1"
        "size"      = "4096"
      }
      "usages"   = ["server auth", "client auth"]
      "dnsNames" = [format("pihole.%s", var.domain)]
      "issuerRef" = {
        "name"  = "ca-issuer"
        "kind"  = "Issuer"
        "group" = "cert-manager.io"
      }
    }
  }
}
