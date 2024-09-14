variable "env" {
  description = "Environment name."
  type        = string
}

variable "eks_name" {
  description = "Name of the cluster."
  type        = string
}

variable "enable_aws-eks-addon" {
  description = "Determines whether to deploy cluster add-on"
  type        = bool
  default     = false
}

variable "aws-ebs-csi_version" {
  description = "aws-ebs-csi version for installation"
  type        = string
}

variable "openid_provider_arn" {
  description = "IAM Openid Connect Provider ARN"
  type        = string
}
