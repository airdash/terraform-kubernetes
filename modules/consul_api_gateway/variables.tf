variable "domain" {
  type = string
}

variable "hostname" {
  type = string
}

variable "metallb_address_pool" {
  type = string
  default = "external-pool"
}

variable "namespace" {
  type = string
  default = "default"
}

# variable "consul_service_name" {
#   type = string
# }
# 
# variable "k8s_service_name" {
#   type = string
# }

variable "service_name" {
  type = string
}

variable "http_listeners" { 
  type = set(object({
    hostname = string
    port = string
  }))
  default = []
}

variable "https_listeners" { 
  type = set(object({
    hostname = string
    port = string
    tls_certificate = string
  }))
  default = []
}

variable "tcp_listeners" { 
  type = set(object({
    hostname = string
    port = string
  }))
  default = []
}

variable "udp_listeners" { 
  type = set(object({
    hostname = string
    port = string
  }))
  default = []
}
