resource "local_file" "ansible_inventory" {
  content = templatefile(
    "${path.module}/../ansible/inventory/inventory.tpl",
    {
      master_ip = yandex_compute_instance.vm_ubuntu[0].network_interface[0].nat_ip_address
      worker_ip = yandex_compute_instance.vm_ubuntu[1].network_interface[0].nat_ip_address
    }
  )
  filename = "${path.module}/../ansible/inventory/inventory.ini"
}

