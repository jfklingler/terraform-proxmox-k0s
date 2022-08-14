# Proxmox k0s Kubernetes Cluster Module

This module creates [k0s Kubernetes clusters](https://k0sproject.io/) on the [Proxmox hypervisor](https://www.proxmox.com/).
The [k0sctl](https://github.com/k0sproject/k0sctl) cluster manager is used for bootstrapping and managing the `k0s` clusters.
There are a number of sub-modules used for configuring a complete cluster.

* [cluster-ssh](modules/cluster-ssh/) - shared cluster SSH configuration
* [control-plane](modules/control-plane/) - LXC container based controller pool configuration
* [load-balancer](modules/load-balancer/) - LXC container based control plane load balancer configuration
* [worker-pool-vm](modules/worker-pool-vm/) - QEMU VM based worker pool configuration

## Providers
These modules make use of the [telmate/proxmox](https://registry.terraform.io/providers/Telmate/proxmox) and [danitso/proxmox](https://registry.terraform.io/providers/danitso/proxmox) providers.
Since they're both named `proxmox`, the `danitso/proxmox` provider has been aliased to `proxmox-resource` because it's only used for creating snippets, etc.
The `telmate/proxmox` provider is used for the management of containers and VMs.

## Compatibility
This module is meant for use with Terraform 1.0+ and tested using Terraform 1.0.
If you find incompatibilities, please open an issue.
This has been tested with Proxmox 6.4, 7.1, and 7.2 but not all features have been tested with all listed versions of proxmox.

## Caveats

### Providers
Some modules make use of [danitso/proxmox](https://registry.terraform.io/providers/danitso/proxmox) ([GitHub](https://github.com/danitso/terraform-provider-proxmox)) specifically for writing cloud-init snippets for QEMU VMs.
This provider appears to be...not currently maintained.
Testing has revealed that snippet resources, and posibly the resulting CDROM volumes, might not be properly destroyed.
These might require deletion after a `terraform destroy` for a complete cleanup.

### Proxmox
When cloning VM templates, Proxmox places a mutex lock on the source.
When creating a more-than-small number of VMs, this will lead to VM creation failures.
Rerunning `terraform apply` will usually rectify the situation.
The problem can also be avoided by specifying `-parallelism=2` (or other suitably small number) during the apply.
This obviously comes at the expense of speed, but waiting longer may be preferable to dealing with multiple apply iterations to complete the cluster setup.

### Personal/Homelab Project
Cloudops is my day job, but these modules were developed as a personal/homelab project.
Only features and configurations that I've experimented with or use regularly, or features that would obviously be needed by thrid parties, are exposed in these modules.
No attempt was made to accommodate all possible permutations of cluster and/or VM configurations.
If a particular feature you need is not exposed, please open an issue or pull request.

### Examples/Tests
Yeah, there kind of aren't any yet.
There are two "tests" which really just amount to a minimal config and an all-the-things config.
I use these locally for testing changes on _my_ Proxmox cluster so, while not particurly great for copy-pasta, they do represent working configurations.
IP allocations, node names, etc. are obviously unique to my setup.
The only missing bits are the Proxmox credentials as defined in the `variables.tf` files.
