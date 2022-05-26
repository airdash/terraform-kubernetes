variable "is_consul_gateway" { 
  type = bool
  default = false 
}

variable "name" { default = "" }
variable "namespace" { default = "kube-system" }
variable "chart_version" { default = "" }
