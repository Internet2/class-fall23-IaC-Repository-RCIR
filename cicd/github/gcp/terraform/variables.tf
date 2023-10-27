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

variable "cluster_name" {
  description = "The name for the GKE cluster"
  default     = "learnk8s-cluster"
}

variable "env_name" {
  description = "The environment for the GKE cluster"
  default     = "prod"
}

variable "network" {
  description = "The VPC network created to host the cluster in"
  default     = "gke-network"
}

variable "subnetwork" {
  description = "The subnetwork created to host the cluster in"
  default     = "gke-subnet"
}

variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
}

variable "ip_range_pods" {
  description = "IP range for pods"
  default     = "10.20.0.0/16"
}

variable "ip_range_services_name" {
  description = "The secondary ip range to use for services"
  default     = "ip-range-services"
}

variable "ip_range_services" {
  description = "IP range for services"
  default     = "10.30.0.0/16"
}

variable "node_machine_type" {
  description = "The machine type for node pool"
  default     = "e2-medium"
}

variable "node_locations" {
  description = "Comma seperated list of locations"
  default     = "us-east1-b,us-east1-c,us-east1-d"
}

variable "node_pool_name" {
  description = "Name of node pool"
  default     = "node-pool"
}

variable "min_nodes" {
  description = "Minimum number of nodes"
  default     = 1
}

variable "max_nodes" {
  description = "Maximum number of nodes"
  default     = 2
}

variable "node_disk_size" {
  description = "Size of node disk in GB"
  default     = 30
}

variable "main_subnet" {
  description = "Main subnet for cluster"
  default     = "10.10.0.0/16"
}