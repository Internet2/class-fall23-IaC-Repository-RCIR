# Terraform configuration file for GCP environment

provider "google" {
  credentials = file("<PATH_TO_SERVICE_ACCOUNT_JSON>") # Replace with the path to your service account JSON file
  project     = "<PROJECT_ID>" # Replace with your project ID
  region      = "us-central1" # Replace with your region
  zone       = "us-central1-a" # Replace with your zone
}