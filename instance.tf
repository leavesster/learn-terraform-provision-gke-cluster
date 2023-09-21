# https://cloud.google.com/compute/docs/images?hl=zh-cn#os-compute-support
# gcloud compute images list --project ubuntu-os-cloud
data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}

resource "google_compute_instance" "machine" {
  name         = "gke-control-panel"
  machine_type = "f1-micro"
  zone         = "${var.region}-a"
  tags         = ["jump"]
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }
  network_interface {
    access_config {
    }
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.subnet.name

  }

  metadata = {
    ssh_keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"

  }
}

resource "google_compute_firewall" "ssh" {
  name = "allow-kube-jump-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }

  direction     = "INGRESS"
  network       = google_compute_network.vpc.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["jump"]
}