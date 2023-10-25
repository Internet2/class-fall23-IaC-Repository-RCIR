variable "account_id" {
  description = "The account id of the aws account (ex: 123456789012)"
  type        = string
}

variable "region" {
  description = "The region the requisite resources will be deployed in"
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "The role name used to access the account"
  type        = string
  default     = "GithubOIDCTerraform"
}

variable "github_repo_name" {
  description = "The name of the target repository to be created"
  type        = string
  default     = "cloud-cicd"
}

variable "github_org" {
  description = "The github org the repository belongs to"
  type        = string
  default     = "myorg"
}

variable "github_oidc_role_name" {
  description = "The name of the github oidc role"
  type        = string
  default     = "GithubOIDC"
}

variable "github_oidc_ecr_policy_name" {
  description = "The name of the github oidc ecr policy"
  type        = string
  default     = "GithubOIDCEcrPolicy"
}

variable "github_oidc_event_access" {
  description = "The github event subject to allow access by"
  type        = string
  default     = "ref:refs/tags/*"
}

variable "github_oidc_provider_url" {
  description = "The github oidc provider URL. Will also be used as the name of the identity provider"
  type        = string
  default     = "token.actions.githubusercontent.com"
}

variable "github_oidc_audience" {
  description = "The github oidc audience required for permissions scope"
  type        = string
  default     = "sts.amazonaws.com"
}

variable "github_oidc_thumbprint" {
  description = "The thumbprint id for github oidc. This is a temporary dummy id since it's required but not used"
  type        = string
  default     = "cf23df2207d99a74fbe169e3eba035e633b65d94"
}