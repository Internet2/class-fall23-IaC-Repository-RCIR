module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google"
  project_id             = "<PROJECT_ID>"
  name                   = "my-cluster"
  regional               = false
  zones                  = ["us-central1-a", "us-central1-b"]
  initial_node_count     = 1
}