Reference: https://medium.com/@ssnetanel/build-a-kubernetes-cluster-using-k3s-on-proxmox-via-ansible-and-terraform-c97c7974d4a5

TODO: move this manual work to ansible proxmox prepare task
https://fredrickb.com/2023/08/05/setting-up-k3s-nodes-in-proxmox-using-terraform/

## QM Setup
On Proxmox node, execute qemu-config.sh which builds the template VM for cloning.

## Terraform Setup

1. The proxmox provider needs to connect via API and is expecting a username/password combo. Set these via the the `secret.sops.yaml` definition.

2. Check quantities of master/workers is correct in `vars.tf`

3. `terraform init / plan / apply` - note this will time out if QEMU agents aren't registering (or installed). Encountered an issue with ZFS lock generation so multiple runs might be required
