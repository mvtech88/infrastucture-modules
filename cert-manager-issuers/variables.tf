variable "env" {
  description = "Environment name."
  type        = string
}

variable "eks_name" {
  description = "Name of the cluster."
  type        = string
}

variable "enable_cert-manager-issuers" {
  description = "Determines whether to deploy cert-manager-issuers application or not."
  type        = bool
  default     = false
}

variable "cert-manager-issuers_helm_version" {
  description = " cert-manager-issuers  Helm version"
  type        = string
}

