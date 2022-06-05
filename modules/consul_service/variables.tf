variable "namespace" {
  type    = string
  default = "default"
}

variable "service_name" {
  type = string
}

variable "dialed_directly" {
  type    = bool
  default = false
}
