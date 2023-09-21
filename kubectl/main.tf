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


provider "kubectl" {
  host                   = data.terraform_remote_state.gke.outputs.kubernetes_cluster_host
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
}

data "kubectl_file_documents" "kuberinstall" {
    content = file("${path.module}/k8s.yaml")
}

resource "kubectl_manifest" "kuberinstall" {
  for_each = data.kubectl_file_documents.kuberinstall.manifests
  yaml_body = each.value
}