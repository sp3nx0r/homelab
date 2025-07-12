terraform {
  required_providers {
    proxmox = {
      # https://github.com/Telmate/terraform-provider-proxmox/issues/863
      source  = "TheGameProfi/proxmox"
      version = "2.9.15"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.2.1"
    }
  }
}
data "sops_file" "proxmox_secrets" {
  source_file = "secret.sops.yaml"
}
provider "proxmox" {
  pm_api_url      = "https://${var.proxmox-host}:8006/api2/json"
  pm_user         = data.sops_file.proxmox_secrets.data["user"]
  pm_password     = data.sops_file.proxmox_secrets.data["password"]
  pm_tls_insecure = "true"
  pm_parallel     = 2
}

resource "proxmox_vm_qemu" "proxmox_vm_master" {
  count = var.num_k3s_masters
  name  = "k3s-master-${count.index}"
  desc  = "k3s-master-${count.index}"
  vmid  = "10${count.index}"

  target_node = var.proxmox-cluster-name
  clone       = var.template_vm_name
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_k3s_masters_mem
  cores       = var.num_k3s_masters_cores
  onboot      = true
  boot        = "c"
  bootdisk    = "virtio0"
  scsihw      = "virtio-scsi-pci"

  ipconfig0  = "ip=192.168.5.8${count.index}/24,gw=${var.nameserver}"
  nameserver = var.nameserver

  lifecycle {
    ignore_changes = [
      target_node,
      network,
      sshkeys,
      qemu_os,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_workers" {
  count = var.num_k3s_nodes
  name  = "k3s-worker-${count.index}"
  desc  = "k3s-worker-${count.index}"
  vmid  = "10${var.num_k3s_masters + count.index}"

  target_node = var.proxmox-cluster-name
  clone       = var.template_vm_name
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_k3s_nodes_mem
  cores       = var.num_k3s_nodes_cores
  onboot      = true
  bootdisk    = "virtio0"
  scsihw      = "virtio-scsi-pci"

  ipconfig0  = "ip=192.168.5.9${count.index}/24,gw=${var.nameserver}"
  nameserver = var.nameserver

  lifecycle {
    ignore_changes = [
      target_node,
      network,
      sshkeys,
      qemu_os,
    ]
  }
}

output "Master-IPS" {
  value = ["${proxmox_vm_qemu.proxmox_vm_master.*.default_ipv4_address}"]
}
output "worker-IPS" {
  value = ["${proxmox_vm_qemu.proxmox_vm_workers.*.default_ipv4_address}"]
}
