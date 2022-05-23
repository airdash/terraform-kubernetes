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

variable "backend_refs" { 
  type = set(object({
    match = set(object({}))
    backendRefs = set(object({}))
  }))
  default = []
}

# variable "backend_refs" { 
#   match = set(object({})
#   type = set(object({
#     backendRefs = set(object({
#       kind = string
#       name = string
#       namespace = string
#       port = integer
#       weight = integer
#   }))
#   default = []
# }
# 
