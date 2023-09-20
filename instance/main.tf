# https://cloud.google.com/compute/docs/images?hl=zh-cn#os-compute-support
# gcloud compute images list --project ubuntu-os-cloud
data "google_compute_image" "ubuntu" {
    family = "ubuntu-2204-lts"
    project = "ubuntu-os-cloud"
}

variable "region" {
    default = "us-central1"
}

variable "project_id" {
  default = "test-390510"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_instance" "machine" {
  name = "jump-server"
  machine_type = "f1-micro"
  zone = "${var.region}-a"
  tags = ["ssh"]
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }
  network_interface {
    access_config {

    }
    network = google_compute_network.jump-server.name
    subnetwork = google_compute_subnetwork.subnet.name
  }

  metadata = {
    ssh-keys = "root:${file("~/.ssh/id_ed25519.pub")}"
  }
}

resource "google_compute_network" "jump-server" {
  name                    = "jumper-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.jump-server.name
  ip_cidr_range = "10.10.0.0/24"
}


resource "google_compute_firewall" "ssh" {
    name = "allow-ssh"
    allow {
      ports = ["22"]
      protocol = "tcp"
    }

    network = google_compute_network.jump-server.name
    direction = "INGRESS"
    priority = 1000
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["ssh"]
}