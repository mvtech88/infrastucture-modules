variable "env" {
  description = "Environment name."
  type        = string
}

variable "eks_name" {
  description = "Name of the cluster."
  type        = string
}

variable "enable_ingress-controller" {
  description = "Determines whether to deploy argocd application"
  type        = bool
  default     = false
}

variable "ingress-controller_helm_verion" {
  description = "Argo CD  Helm verion"
  type        = string
}

variable "openid_provider_arn" {
  description = "IAM Openid Connect Provider ARN"
  type        = string
}
