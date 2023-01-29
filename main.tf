terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token = ""
#  cloud_id  = var.cloud_id
  folder_id = "b1g817nmob937losobc1"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "rmq" {
  count = 2
  name = "rmq${count.index}"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8m8s42796gm6v7sf8e"
      size = 3
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  
  metadata = {
    user-data = "${file("/home/paromov/terraform_nginx/meta.txt")}"
  }

}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "server_name" {
  value = yandex_compute_instance.rmq[*].name
}

output "internal_ip_address_server" {
  value = yandex_compute_instance.rmq[*].network_interface.0.ip_address
}
output "external_ip_address_server" {
  value = yandex_compute_instance.rmq[*].network_interface.0.nat_ip_address
}
