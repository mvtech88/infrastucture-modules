terraform {
  required_version = ">= 1.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7.0"

   }
   
  }
}
