
resource "helm_release" "cert-manager-issuers" {
  count = var.enable_cert-manager-issuers ? 1 : 0

  name = "${var.env}-cert-manager-issuers"

  repository = "https://charts.adfinis.com"
  chart      = "cert-manager-issuers"
  namespace  = "cert-manager"
  version    = var.cert-manager-issuers_helm_version
  create_namespace = true
  timeout          = "1200"
  force_update	   = true

  values = [
    templatefile("${path.module}/cert-manager-issuers.yaml", { env = "${var.env}" })
  ]

}

#data "aws_ssm_parameter" "ssh_private_key" {
#  name = var.aws_ssm_key_name
#}

