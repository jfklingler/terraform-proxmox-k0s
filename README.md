# Proxmox k0s Kubernetes Cluster Module

This module creates [k0s Kubernetes clusters](https://k0sproject.io/) on the [Proxmox hypervisor](https://www.proxmox.com/).
The [k0sctl](https://github.com/k0sproject/k0sctl) cluster manager is used for bootstrapping and managing the `k0s` clusters.
There are a number of sub-modules used for configuring a complete cluster.

* [Cluster SSH Config](modules/cluster-ssh/)
* [Control Plane (LXC)](modules/control-plane/)
* [Load Balancer (LXC)](modules/load-balancer/)
* [Worker Pool (QEMU)](modules/worker-pool-vm/)

## Providers
These modules make use of the [telmate/proxmox](https://registry.terraform.io/providers/Telmate/proxmox) and [danitso/proxmox](https://registry.terraform.io/providers/danitso/proxmox) providers.
Since they're both named `proxmox`, the `danitso/proxmox` provider has been aliased to `proxmox-resource` because it's only used for creating snippets, etc.
The `telmate/proxmox` provider is used for the management of containers and VMs.

## Compatibility
This module is meant for use with Terraform 1.0+ and tested using Terraform 1.0.
If you find incompatibilities, please open an issue.
Proxmox 6.4, 7.1, and 7.2 have been used in live environments.
Not all features have been tested with all listed versions of proxmox.

## Caveats
Some modules make use of [danitso/proxmox](https://registry.terraform.io/providers/danitso/proxmox) ([GitHub](https://github.com/danitso/terraform-provider-proxmox)) specifically for writing cloud-init snippets for QEMU VMs.
This provider appears to be...not currently maintained.
Testing has revealed that snippet resources, and posibly the resulting CDROM volumes, might not be properly destroyed.
These might require deletion after a `terraform destroy` for a complete cleanup.

These modules were developed over time as I experimented with different features.
No attempt was made to accommodate all possible permutations of cluster and/or VM configurations.
If a particular feature you need is not exposed, please open an issue.
