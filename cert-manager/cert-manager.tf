data "aws_iam_openid_connect_provider" "this" {
  arn = var.openid_provider_arn
}

data "aws_iam_policy_document" "cert-manager" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:${var.env}-cert-manager"]
    }

    principals {
      identifiers = [data.aws_iam_openid_connect_provider.this.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "cert-manager" {
  count = var.enable_cert-manager ? 1 : 0

  assume_role_policy = data.aws_iam_policy_document.cert-manager.json
  name               = "${var.eks_name}-cert-manager"
}

resource "aws_iam_policy" "CertManagerRoute53Access" {
  count = var.enable_cert-manager ? 1 : 0

  name = "${var.eks_name}-cert-manager"

  policy = jsonencode({
    "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "route53:GetChange",
      "Resource": "arn:aws:route53:::change/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ],
      "Resource": "arn:aws:route53:::hostedzone/Z100992510LUGZYBTY35U"
    }
  ]
  })
}

resource "aws_iam_role_policy_attachment" "cert-manager" {
  count = var.enable_cert-manager ? 1 : 0

  role       = aws_iam_role.cert-manager[0].name
  policy_arn = aws_iam_policy.CertManagerRoute53Access[0].arn
}

resource "helm_release" "cert-manager" {
  count = var.enable_cert-manager ? 1 : 0

  name = "${var.env}-cert-manager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "kube-system"
  version    = var.cert-manager_helm_version

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.cert-manager[0].arn
  }

  set {
    name  = "extraArgs[0]"
    value = "--issuer-ambient-credentials"
  }
 
  set {
    name  = "prometheus.enabled"
    value = "true"
  }

  set {
    name  = "prometheus.servicemonitor.enabled"
    value = "true"
  }

# You can provide a map of value using yamlencode. Don't forget to escape the last element after point in the name
  set {
    name  = "prometheus.servicemonitor\\.labels"
    type  = "string"
    value = <<-YAML
      prometheus: monitoring
      YAML
  }

}
