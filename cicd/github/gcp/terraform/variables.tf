variable "project_id" {
  description = "The id of the project for the terraform to create resources in"
  type        = string
}

variable "github_org" {
  description = "The name of the github org (or personal account)"
  type        = string
}

variable "github_repo" {
  description = "The name of the github repository"
  type        = string
}

variable "region" {
  description = "The region in which to create resources in"
  type        = string
  default     = "us-east1"
}

variable "github_oidc_service_account" {
  description = "The name of the service account for github oidc"
  type        = string
  default     = "github-oidc-account"
}

variable "github_oidc_workload_identity_pool_id" {
  description = "The id of the github oidc workload identity pool"
  type        = string
  default     = "github-oidc-pool"
}

variable "github_oidc_workload_identity_pool_name" {
  description = "The display name of the github oidc workload identity pool"
  type        = string
  default     = "Github OIDC Pool"
}

variable "github_oidc_workload_identity_pool_provider_id" {
  description = "The provider id for the workload identity pool"
  type        = string
  default     = "github-oidc-provider"
}

variable "github_oidc_workload_identity_pool_provider_name" {
  description = "The provider display name for the workload identity pool"
  type        = string
  default     = "Github OIDC Provider"
}

variable "github_oidc_workload_identity_pool_provider_url" {
  description = "The github oidc provider URL. Will also be used as the name of the identity provider"
  type        = string
  default     = "token.actions.githubusercontent.com"
}