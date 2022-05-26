variable "cert_manager_issuer" { default = "letsencrypt-staging" }

variable "domain" {
  type = string
}

variable "hostnames" {
  type = string
}

variable "name" {
  type = string
}

variable "wildcard" {
  type = bool
  default = false
}

variable "namespace" {
  type = string
  default = "default"
}
