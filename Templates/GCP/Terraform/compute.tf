# Terraform configuration file for creating a GCP VM

resource "google_compute_instance" "jupyter_vm" {
  name         = "jupyter-vm"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = "default"
  }
}