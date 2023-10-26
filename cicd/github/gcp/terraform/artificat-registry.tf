resource "google_artifact_registry_repository" "default" {
  repository_id = var.github_repo
  location      = var.region
  format        = "DOCKER"
}