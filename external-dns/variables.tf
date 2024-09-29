variable "env" {
  description = "Environment name."
  type        = string
}

variable "eks_name" {
  description = "Name of the cluster."
  type        = string
}

variable "enable_external-dns" {
  description = "Determines whether to deploy external dns"
  type        = bool
  default     = false
}

variable "external-dns_helm_version" {
  description = "external dns Helm verion"
  type        = string
}

variable "openid_provider_arn" {
  description = "IAM Openid Connect Provider ARN"
  type        = string
}
