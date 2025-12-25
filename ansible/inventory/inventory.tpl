[MasterNodes]
master-node ansible_host=${master_ip}

[WorkerNodes]
worker-node ansible_host=${worker_ip}

[vm:children]
MasterNodes
WorkerNodes

[vm:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_ed25519
