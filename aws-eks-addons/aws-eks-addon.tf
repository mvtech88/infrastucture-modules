data "aws_iam_openid_connect_provider" "this" {
  arn = var.openid_provider_arn
}

data "aws_iam_policy_document" "csi" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    principals {
      identifiers = [data.aws_iam_openid_connect_provider.this.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "amazon_ebs_csi_driver" {
  count = var.enable_aws-eks-addon ? 1 : 0

  assume_role_policy = data.aws_iam_policy_document.csi.json
  name               = "${var.eks_name}-amazon_ebs_csi_driver"
}


resource "aws_iam_role_policy_attachment" "aws-eks-addon" {
  count = var.enable_aws-eks-addon ? 1 : 0

  role       = aws_iam_role.amazon_ebs_csi_driver[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_eks_addon" "csi_driver" {
  cluster_name             = var.eks_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = var.aws-ebs-csi_version
  service_account_role_arn = aws_iam_role.amazon_ebs_csi_driver[0].arn
}

