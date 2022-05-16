provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    host        = https://kubernetes-master-canal-01.sour.ninja:6443
  }
}

