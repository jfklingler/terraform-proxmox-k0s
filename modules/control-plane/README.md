# Cluster Control Plane Configuration (LXC)

This module is responsible for creating the k0s cluster controller VMs.
When creating more than a single controller, odd numbers are recommended for `node_count`.
All VMs will be created on the same proxmox node.

## Networking

While "normal" DHCP would not be desireable since IPs could change, it's entirely possible to configre DHCP for static assignments.
Unfortunately, the [proxmox provider](https://registry.terraform.io/providers/telmate/proxmox) does not support retrieving the IP address from a VM that uses DHCP.
The IP addresses are needed by `k0sctl` for cluster configuration.
Because of this, we must assign IPs statically during VM creation.
The way this has been designed in these modules is that a subnet CIDR block is allocated for each "pool" of VMs, be they controllers or workers.
The CIDR block need not be the entire network, of course.
For example if the network is `10.1.2.0/24`, a subnet of `10.1.2.192/29` could be used for a pool of VMs.
Care must taken that any DHCP service on the network will not allocate IPs from the subnet range.
A base index into that CIDR block is then used to select an IP for each VM.
This combination lets us share a single subnet for multiple pools.
For example, if the subnet is `10.1.2.128/26`, the controller load balancer could use index 0, giving it IP `10.1.2.128`, the controllers (pool of 3) could use a base index of 1, giving them IPs `10.1.2.129`-`10.1.2.131`, and finally a worker pool (pool of 10) could use a base index of 5, giving them IPs `10.1.2.133`-`10.1.2.142`.
