resource "google_compute_disk" "stata_disk" {
  name  = "stata-disk"
  type  = "pd-standard"
  size  = 500
  zone  = "us-central1-a"
}