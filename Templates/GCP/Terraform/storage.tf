provider "google" {
  credentials = file("<PATH_TO_SERVICE_ACCOUNT_JSON>")
  project     = "<PROJECT_ID>"
  region      = "us-central1"
}

resource "google_storage_bucket" "research_data_bucket" {
  name     = "my-research-data-bucket"
  location = "US"
}