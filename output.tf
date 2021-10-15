output "webserver_url" {
  value = "http://${google_compute_instance.vm.network_interface.0.access_config.0.nat_ip}" 
}

output "message" {
  value = "Please wait a while before accessing the URL"
}