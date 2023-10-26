resource "google_service_account" "default" {
  account_id = var.github_oidc_service_account
}

resource "google_iam_workload_identity_pool" "default" {
  description               = "Identity pool for github oidc"
  workload_identity_pool_id = var.github_oidc_workload_identity_pool_id
  display_name              = var.github_oidc_workload_identity_pool_name
  disabled                  = false
}

resource "google_iam_workload_identity_pool_provider" "default" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.default.workload_identity_pool_id
  workload_identity_pool_provider_id = var.github_oidc_workload_identity_pool_provider_id
  display_name                       = var.github_oidc_workload_identity_pool_provider_name
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }
  oidc {
    issuer_uri = "https://${var.github_oidc_workload_identity_pool_provider_url}"
  }
}

resource "google_service_account_iam_binding" "default" {
  service_account_id = google_service_account.default.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.default.name}/attribute.repository/${var.github_org}/${var.github_repo}"
  ]
}

resource "google_project_iam_binding" "default" {
  members = [
    "serviceAccount:${google_service_account.default.email}"
  ]
  project = var.project_id
  role    = "roles/artifactregistry.admin"
}