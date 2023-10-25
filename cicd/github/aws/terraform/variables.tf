variable "account_id" {
  description = "The account id of the aws account (ex: 123456789012)"
  type        = string
}

variable "role_name" {
  description = "The role name used to access the account"
  type        = string
  value       = "GithubOICDTerraform"
}

variable "region" {
  description = "The region the requisite resources will be deployed in"
  type        = string
  value       = "us-east-1"
}

variable "github_repo_name" {
  description = "The name of the target repository to be created"
  type        = string
  value       = "cloud-cicd"
}

variable "github_org" {
  description = "The github org the repository belongs to"
  type        = string
  value       = "myorg"
}

variable "github_oicd_role_name" {
  description = "The name of the github oicd role"
  type        = string
  value       = "GithubOICD"
}

variable "github_oicd_ecr_policy_name" {
  description = "The name of the github oicd ecr policy"
  type        = string
  value       = "GithubOICDEcrPolicy"
}

variable "github_event_access" {
  description = "The github event subject to allow access by"
  type        = string
  value       = "ref:refs/tags/*"
}