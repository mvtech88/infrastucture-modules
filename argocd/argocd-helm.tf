data "aws_ssm_parameter" "ssh_private_key" {
  name = var.aws_ssm_key_name
}

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

#  set {
#    name  = "server.service.annotations[0]"
#    value = "service.beta.kubernetes.io/aws-load-balancer-type: external"
#  }
#  set {
#    name  = "server.service.annotations[1]"
#    value = "service.beta.kubernetes.io/aws-load-balancer.scheme: internet-facing"
#  }
#  set {
#    name  = "server.service.annotations[2]"
#    value = "service.beta.kubernetes.io/aws-load-balancer-type: nlb"
#  }

}

