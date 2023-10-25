resource "google_compute_instance" "matlab_vm" {
  count        = 3
  name         = "matlab-vm-${count.index}"
  machine_type = "n1-standard-2"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
}