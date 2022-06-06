module "consul_service" {
  count           = 1
  namespace       = "grafana"
  source          = "../../modules/consul_service"
  service_name    = "grafana"
  dialed_directly = true
}

