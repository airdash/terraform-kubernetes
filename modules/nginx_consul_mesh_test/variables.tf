variable "name" {}
variable "domain" { default = "sour.ninja" }

variable "use_nginx_ingress" {
  type    = bool
  default = false
}

variable "nginx_ingress_class" { default = "nginx" }
