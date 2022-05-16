module "calico_cni" {
  source = "../../modules/calico_cni"
}

module "consul" {
  count = 1
  depends_on = [ module.csi_driver_nfs, module.metallb ]
  source = "../../modules/consul"
}

module "csi_driver_nfs" {
  depends_on = [ module.calico_cni ]
  source = "../../modules/csi_driver_nfs"
}

module "metallb" {
  depends_on = [ module.calico_cni ]
  source = "../../modules/metallb"
}

module "nfs_subdir_external_provisioner" {
  depends_on = [ module.calico_cni ]
  source = "../../modules/nfs_subdir_external_provisioner"
}

module "nginx_consul_mesh_test" {
  count = 0
  depends_on = [ module.consul ]
  source = "../../modules/sample_services/nginx_consul_mesh_test"
}

module "pihole" {
  count = 1
  depends_on = [ module.calico_cni ]
  domain = "sour.ninja"
  source = "../../modules/pihole"
}

module "externaldns" {
  count = 1
  depends_on = [ module.consul ]
  source = "../../modules/externaldns"
}

module "cert_manager" {
  count = 1
  depends_on = [ module.calico_cni ]
  source = "../../modules/cert_manager"
}

