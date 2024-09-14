data "aws_iam_openid_connect_provider" "this" {
  arn = var.openid_provider_arn
}

data "aws_iam_policy_document" "external-dns" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:${var.env}-external-dns"]
    }

    principals {
      identifiers = [data.aws_iam_openid_connect_provider.this.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "external-dns" {
  count = var.enable_external-dns ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.external-dns.json
  name               = "${var.eks_name}-external-dns"
}

resource "aws_iam_policy" "external-dnsAccess" {
  count = var.enable_external-dns ? 1 : 0

  name = "${var.eks_name}-external-dns"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones",
                "route53:ListResourceRecordSets"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "external-dns" {
  count = var.enable_external-dns ? 1 : 0

  role       = aws_iam_role.external-dns[0].name
  policy_arn = aws_iam_policy.external-dnsAccess[0].arn
}

resource "helm_release" "external-dns" {
  count = var.enable_external-dns ? 1 : 0

  name = "${var.env}-external-dns"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  namespace  = "kube-system"
  version    = var.external-dns_helm_version

  set {
    name  = "aws.zoneType"
    value = "public"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.external-dns[0].arn
  }

  set {
    name  = "extraArgs.source"
    value = "service"
  }

 
  set {
    name  = "extraArgs.txt-owner-id"
    value = "eks-identifier"
  }

}
