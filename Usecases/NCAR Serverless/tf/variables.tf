variable "project_id" {
  description = "The project ID to host the cluster in"
  default     = "i2class-fall2023-dgottlieb"
}
variable "cluster_name" {
  description = "The name for the GKE cluster"
  default     = "learnk8s-cluster"
}
variable "env_name" {
  description = "The environment for the GKE cluster"
  default     = "prod"
}
variable "region" {
  description = "The region to host the cluster in"
  default     = "us-west1"
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
  default     = "us-west1-a,us-west1-b,us-west1-c"
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