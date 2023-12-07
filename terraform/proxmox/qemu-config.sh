#! /bin/bash

# reference blog: https://medium.com/@ssnetanel/build-a-kubernetes-cluster-using-k3s-on-proxmox-via-ansible-and-terraform-c97c7974d4a5
# reference script: https://gist.github.com/ilude/457f2ef2e59d2bff8bb88b976464bb91
# This script prepares the cloud-init image used in subsequent terraform steps

# change this if default storage is not used
CLUSTER_STORAGE="local-zfs"

wget -nc https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
virt-customize -a jammy-server-cloudimg-amd64.img --install qemu-guest-agent

# Create a VM
qm create 9000 --name ubuntu-jammy-templ --memory 1024 --sockets 1 --cores 1 --machine q35 --bios seabios --net0 virtio,bridge=vmbr0

# Import the downloaded disk to $CLUSTER_STORAGE
qm importdisk 9000 jammy-server-cloudimg-amd64.img "${CLUSTER_STORAGE}"

# finally attach the new disk to the VM as scsi drive
qm set 9000 --scsihw virtio-scsi-pci  --virtio0 "${CLUSTER_STORAGE}":vm-9000-disk-0,discard=on
# add cloud-init image to the VM
qm set 9000 --ide2 "${CLUSTER_STORAGE}":cloudinit
# set the VM to boot from the cloud-init disk:
qm set 9000 --boot c --bootdisk virtio0
qm set 9000 --serial0 socket --vga serial0
# Using a dhcp server on vmbr1 or use static IP
qm set 9000 --ipconfig0 ip=dhcp

# always restart vm on boot
qm set 9000 --onboot=1

# enable the QEMU guest agent
qm set 9000 --agent enabled=1

# expand the disk since proxmox terraform provider has difficulty doing expansion
qm resize 9000 virtio0 +48G

# user authentication for 'ubuntu' user (optional password)
tail -n 1 ~/.ssh/authorized_keys > /tmp/ssh_key_from_ansible
qm set 9000 --sshkey /tmp/ssh_key_from_ansible

qm template 9000
