# https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-provider

terraform {
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.4.1"
    }
  }
}

data "terraform_remote_state" "gke" {
    backend = "local"
    config = {
        path = "../terraform.tfstate"
    }
  
}

provider "google" {
  project = data.terraform_remote_state.gke.outputs.project_id
  region  = data.terraform_remote_state.gke.outputs.region
}

data "google_container_cluster" "gke" {
    name     = data.terraform_remote_state.gke.outputs.kubernetes_cluster_name
    location = data.terraform_remote_state.gke.outputs.region
}

data "google_client_config" "default" {}


provider "kubernetes" {
  host = data.terraform_remote_state.gke.outputs.kubernetes_cluster_host
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
}