# https://cloud.google.com/compute/docs/images?hl=zh-cn#os-compute-support
# gcloud compute images list --project ubuntu-os-cloud
data "google_compute_image" "ubuntu" {
   family = "ubuntu-2204-lts"
    project = "ubuntu-os-cloud"
}

resource "google_compute_instance" "machine" {
  name = "gke-control-panel"
  machine_type = "f1-micro"
  zone = "${var.region}-a"
  tags = ["ssh"]
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {

    }
  }
}

resource "google_compute_firewall" "ssh" {
    name = "allow-ssh"
    allow {
      ports = ["22"]
      protocol = "tcp"
    }

    direction = "INGRESS"
    network = google_compute_network.vpc.id
    priority = 1000
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["ssh"]
}