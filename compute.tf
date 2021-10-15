data "google_compute_image" "ubuntu" {
  name  = "ubuntu-2004-focal-v20210927"
  project = "ubuntu-os-cloud"
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-rule"
  network = "default"
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
  target_tags = ["allow-http"]
  priority    = 1000

}

#allow http and https
resource "google_compute_firewall" "allow_https" {
  name    = "allow-https-rule"
  network = "default"
  allow {
    ports    = ["443"]
    protocol = "tcp"
  }
  target_tags = ["allow-https"]
  priority    = 1001

}


# Creates a GCP VM Instance.
resource "google_compute_instance" "vm" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["allow-http","allow-https"]
  labels       = var.labels

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = data.template_file.nginx.rendered
}

data "template_file" "nginx" {
  template = "${file("${path.module}/template/configurevm.tpl")}"

  vars = {
    ufw_allow_nginx = "Nginx HTTP"
  }
}

