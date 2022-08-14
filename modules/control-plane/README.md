# Cluster Control Plane Configuration (LXC)

This module is responsible for creating the k0s cluster controller nodes as LXC containers.
When creating more than a single controller, odd numbers are recommended for `node_count`.
All controller nodes will be created on the same proxmox node.

This module's outputs are compatible with the outputs of the [load-balancer](../load-balancer/) module so that either can be used as the `control_plane` input of the [primary module](/../../).
This allows both small, single node control planes as well as larger, multi-node control planes to be used interchangeably.

## Networking

While "normal" DHCP would not be desireable since IPs could change, it's entirely possible to configre DHCP for static assignments.
Unfortunately, neither of the proxmox providers support retrieving the IP address from a VM or container that uses DHCP.
The IP addresses are needed by `k0sctl` for cluster configuration.
Because of this, we must assign IPs statically during VM creation.
The way this has been designed in these modules is that a subnet CIDR block is allocated for each "pool" of VMs, be they controllers or workers.
The CIDR block need not be the entire network, of course.
For example if the network is `10.1.2.0/24`, a subnet of `10.1.2.192/29` could be used for a pool of VMs.
Care must taken that any DHCP service on the network will not allocate IPs from the subnet range.
A base index into that CIDR block is then used to select an IP for each VM.
This combination lets us share a single subnet for multiple pools.
For example, if the subnet is `10.1.2.128/26`, the controller load balancer could use index 0, giving it IP `10.1.2.128`, the controllers (pool of 3) could use a base index of 1, giving them IPs `10.1.2.129`-`10.1.2.131`, and finally a worker pool (pool of 10) could use a base index of 5, giving them IPs `10.1.2.133`-`10.1.2.142`.

## Multi-Node Configuration

There are two basic methods for configuring a multi-node control plane using these modules.
Neither is objectively better than the other, so you need to consider your setup and what you want out of your cluster.

### Proxmox HA (or Highlander Proxmox)
One is create a single instance of this module with multiple nodes, i.e, `node_count` == the number of controller nodes you want.
This will create all controller nodes on the same Proxmox node, so this should only be used with properly a configured and tested Proxmox HA configuration.
The other acceptable way to use this is when there's only one Proxmox node and if it's down, everything is down, so lacking a control plane is of no real consequence.
Highlander Proxmox: there can be only one...node.
Get it?
Yeah, I'll show myself out.

### Manual Distribution
The other method is to create multiple instances of this module, each assigning some portion of the number of controller nodes desired to different Proxmox nodes.
This might be desireable if you have non-uniform Proxmox nodes.
This is not unusual in homelab environments...well, homelab evnironments with a Proxmox _cluster_ anyway...
One thing to keep in mind is that you'll most likely still want Proxmox HA configured for the control plane's HAProxy load balancer.
You can have a lesser amount of reserved resources across your Proxmox cluster for HA migration if only the load balancer needs to migrate.
