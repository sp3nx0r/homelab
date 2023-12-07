
variable "proxmox-host" {
  description = "The IP for proxmox host"
  type        = string
  default     = "192.168.5.10"
}

variable "proxmox-cluster-name" {
  description = "The name for proxmox cluster"
  type        = string
  default     = "proxmox"
}

variable "nameserver" {
  description = "The IP for gateway"
  type        = string
  default     = "192.168.5.1"
}

variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}

variable "num_k3s_masters" {
  default = 1
}

variable "num_k3s_masters_mem" {
  default = "8192"
}

variable "num_k3s_masters_cores" {
  default = "2"
}

variable "num_k3s_nodes" {
  default = 3
}

variable "num_k3s_nodes_mem" {
  default = "8192"
}

variable "num_k3s_nodes_cores" {
  default = "2"
}

variable "template_vm_name" {
  default = "ubuntu-jammy-templ"
}
