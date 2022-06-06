module "calico_cni" {
  source = "../../modules/calico_cni"
}

module "consul" {
  count      = 1
  depends_on = [module.csi_driver_nfs, module.metallb]
  source     = "../../modules/consul"
}

module "csi_driver_nfs" {
  depends_on = [module.calico_cni]
  source     = "../../modules/csi_driver_nfs"
}

module "metallb" {
  depends_on = [module.calico_cni]
  source     = "../../modules/metallb"
}

module "nfs_subdir_external_provisioner" {
  depends_on = [module.calico_cni]
  source     = "../../modules/nfs_subdir_external_provisioner"
}

module "pihole" {
  count      = 1
  depends_on = [module.calico_cni]
  domain     = "sour.ninja"
  source     = "../../modules/pihole"
}

module "externaldns" {
  count      = 1
  depends_on = [module.consul]
  source     = "../../modules/externaldns"
}

module "cert_manager" {
  count      = 1
  depends_on = [module.calico_cni]
  source     = "../../modules/cert_manager"
}

module "nginx_ingress_controller" {
  count      = 1
  depends_on = [module.calico_cni]
  source     = "../../modules/nginx_ingress_controller"
}

module "nginx_ingress_controller_consul" {
  count      = 1
  depends_on = [module.calico_cni]

  name = "ingress-nginx-consul"
  namespace = "consul-system"
  source     = "../../modules/nginx_ingress_controller"
  is_consul_gateway  = true
}

module "vault" {
  count      = 1
  depends_on = [module.calico_cni]
  source     = "../../modules/vault"
}

module "grafana" {
  count      = 1
  depends_on = [module.calico_cni]
  source     = "../../modules/grafana"
}
