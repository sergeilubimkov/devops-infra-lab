terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = var.zone
  service_account_key_file = "/home/t/devops-infra-lab/key.json"
  cloud_id = var.cloud_id
  folder_id = var.folder_id
}


resource "yandex_vpc_network" "network" { 
    name = "devops-network"
}

resource "yandex_vpc_subnet" "subnet"{ 
    name = "devops-subnet"
    zone = var.zone
    network_id = yandex_vpc_network.network.id
    v4_cidr_blocks = ["192.168.1.0/24"]
}

resource "yandex_vpc_security_group" "security_group" {
  name = "devops-security-g"
  network_id = yandex_vpc_network.network.id

  ingress{
    protocol = "TCP"
    port =22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol = "TCP"
    port = 9000
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 30080
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress{
    protocol = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "yandex_compute_disk" "boot_disk"{
    count = 2
    name = "my-boot-disk-${count.index}"
    zone = var.zone
    size = "50"
    image_id = "fd8umfn3mighedglnjue"
}

resource "yandex_compute_instance" "vm_ubuntu" {
  count = 2
  name = "vm-${count.index}-terraform"
  zone = var.zone
    resources {
        cores = 4
        memory = 4
    }

    boot_disk{
        auto_delete = true
        disk_id  = yandex_compute_disk.boot_disk[count.index].id
    }

    network_interface {
        subnet_id = yandex_vpc_subnet.subnet.id 
        nat = true
        security_group_ids = [yandex_vpc_security_group.security_group.id]
    }

    metadata = {
        ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
    }

}


