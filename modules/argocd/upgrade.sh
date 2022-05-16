helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade -n infra argocd argo/argo-cd -f values.yaml
