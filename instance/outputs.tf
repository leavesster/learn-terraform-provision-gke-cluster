output "instance_ip" {
    value = google_compute_instance.machine.network_interface.0.access_config.0.nat_ip
    description = "value of the instance ip"
    depends_on = [ null_resource.patience ]
}

resource "null_resource" "patience" {
  depends_on = [ google_compute_instance.machine ]
  triggers = {
    ip = google_compute_instance.machine.network_interface.0.access_config.0.nat_ip
  }

    provisioner "local-exec" {
        command = "sleep 60"
    }
}