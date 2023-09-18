resource "kubernetes_ingress_v1" "nginx" {
  metadata {
    name = "ng"
  }

  spec {
    default_backend {
      service {
        name = "ng-svc"
        port {
            number = 8080
        }
      }
    }
  }
}

resource "kubernetes_service" "ng_svc" {
  metadata {
    name = "ng-svc"
  }
  spec {
    selector =  kubernetes_deployment.nginx.metadata[0].labels
    port {
        port = 8080
        target_port = 80
    }
    type = "NodePort"
  }
}

output "ingress" {
  value = kubernetes_ingress_v1.nginx.status.0.load_balancer.0.ingress
  description = "value of ingress ip"
}