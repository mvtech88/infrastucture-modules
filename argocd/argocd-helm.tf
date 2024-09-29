resource "helm_release" "argocd" {
  count = var.enable_argocd ? 1 : 0

  name = "${var.env}-argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = var.argocd_helm_verion
  create_namespace = true
  timeout          = "1200"
  force_update	   = true
 
  values = [
    templatefile("${path.module}/argocd.yaml", { env = "${var.env}" })
  ]

}

