variable "cert_manager_issuer" { default = "letsencrypt-staging" }

variable "domain" {
  type = string
}

variable "hostname" {
  type = string
}

variable "metallb_address_pool" {
  type    = string
  default = "external-pool"
}

variable "name" {
  type = string
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "listeners" {
  type    = set(object({}))
  default = []
}
