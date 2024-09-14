variable "env" {
  description = "Environment name."
  type        = string
}

variable "eks_name" {
  description = "Name of the cluster."
  type        = string
}

variable "enable_kube-prometheus-stack" {
  description = "Determines whether to deploy kube-prometheus-stack application"
  type        = bool
  default     = false
}

variable "kube-prometheus-stack_helm_version" {
  description = " kube-prometheus-stack  Helm version"
  type        = string
}

variable "enable_defaultdashboard" {
  description = "This parameter will enable the default dashboard if set to true"
  type        = string
}


