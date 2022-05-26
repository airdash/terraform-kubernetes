module "nginx_consul_mesh_test" {
  count = 2
  depends_on = [ module.consul ]
  source = "../../modules/nginx_consul_mesh_test"

  name = "nginx-test-${count.index}"
}

module "nginx_consul_api_route" {
  count = 2
  depends_on = [ module.consul ]
  source = "../../modules/consul_api_route"

  domain = "sour.ninja"
  gateway = module.nginx_consul_test_gateway.name
  service_name = module.nginx_consul_mesh_test.name[count.index]

  rules = [{
    matches = [{
      path = [{
        "type" = "PathPrefix"
        "value" = "/"
      }]
    }]

    backendRefs = [{
      "kind"      = "Service"
      "name"      = module.nginx_consul_mesh_test.name[count.index]
      "namespace" = "default"
      "port"      = 80
    },
    {
      "kind"      = "Service"
      "name"      = module.nginx_consul_mesh_test.name[count.index]
      "namespace" = "default"
      "port"      = 443
    }]
  }]
}

module "nginx_consul_test_gateway" {
  count = 1
  depends_on = [ module.consul ]
  cert_manager_issuer = "letsencrypt-staging"
  hostname = "nginx-shared-gateway"
  domain   = "sour.ninja"
  source = "../../modules/consul_api_gateway"

  name = "nginx-test-shared-gateway"
  metallb_address_pool = "external-pool"

  listeners  = [{
    
}
