module "nginx_consul_mesh_test" {
  count      = 2
  depends_on = [module.consul]
  source     = "../../modules/nginx_consul_mesh_test"

  name = "nginx-test-${count.index}"

  use_nginx_ingress   = true
  nginx_ingress_class = "nginx-consul-test"
}

# module "nginx_consul_ingress" {
#   count = 2
#   depends_on = [ module.consul ]
#   source = "../../modules/nginx_consul_ingress"
# 
#   name = "nginx-test-ingress-${count.index}"
# }

module "nginx_test_ingress_controller" {
  count             = 1
  name              = "nginx-consul-test"
  namespace         = "default"
  is_consul_gateway = true

  source = "../../modules/nginx_ingress_controller"
}

module "nginx_consul_api_route" {
  count      = 0
  depends_on = [module.consul]
  source     = "../../modules/consul_api_route"

  domain       = "sour.ninja"
  hostname     = "nginx-test"
  gateway      = module.nginx_consul_test_gateway[0].name
  service_name = module.nginx_consul_mesh_test[count.index].name

  rules = [{
    matches = [{
      path = [{
        "type"  = "PathPrefix"
        "value" = "/"
      }]
    }]

    backendRefs = [{
      "kind"      = "Service"
      "name"      = module.nginx_consul_mesh_test[count.index].name
      "namespace" = "default"
      "port"      = 80
      },
      {
        "kind"      = "Service"
        "name"      = module.nginx_consul_mesh_test[count.index].name
        "namespace" = "default"
        "port"      = 443
    }]
  }]
}

module "nginx_consul_test_gateway" {
  count               = 0
  depends_on          = [module.consul]
  cert_manager_issuer = "letsencrypt-staging"
  hostname            = "nginx-shared-gateway"
  domain              = "sour.ninja"
  source              = "../../modules/consul_api_gateway"

  name                 = "nginx-test-shared-gateway"
  metallb_address_pool = "external-pool"

  listeners = []
}
