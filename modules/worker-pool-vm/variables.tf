variable "cluster_name" {
  description = "The name of the k0s cluster; informational; used in proxmox resource names"

  type    = string
  default = "default"
}

variable "name" {
  description = "The name of the worker pool; informational; used in proxmox resource names"

  type    = string
  default = "default"
}

variable "node_count" {
  description = "How many VMs to create. Should be an odd number in most cases. Default 1."

  type    = number
  default = 1
}

variable "pve" {
  description = <<-EOT
  Proxmox cluster configuration.
  See the proxmox documentation for more information.

  * node - The name of the proxmox node to deploy VMs on
  * pool - The name proxmox resource pool to create resources in; optional
  * base_vmid - The first VMID used when not letting proxmox allocate VMIDs automatically; optional
  EOT

  type = object({
    node      = string
    pool      = optional(string)
    base_vmid = optional(number)
  })
}

variable "os" {
  description = <<-EOT
  The VM operating system configuration.
  See the proxmox documentation for more information.

  * template - The VM template to clone
  * linked - Whether to create a linked clone; default false
  * upgrade - Whether to perform package upgrades during cloud-init; default false
  * storage -
     * cdrom - The proxmox storage pool for the cloud-init CD-ROM volume
     * snippet - The proxmox storage pool for the cloud-init contents
  EOT

  type = object({
    template = string
    linked   = optional(bool)
    upgrade  = optional(bool)
    storage = object({
      cdrom   = string
      snippet = string
    })
  })
}

locals {
  os = defaults(var.os, {
    linked  = false
    upgrade = false
  })
}

variable "cpu" {
  description = <<-EOT
  The CPU configuration for each VM.
  See the proxmox documentation for more information.

  * cores - The number of cores to allocate; default 2
  * sockets - The number of sockets to present; default 1
  * type - The CPU type; default "host"
  * numa - Whether NUMA should be enabled; default false
  EOT

  type = object({
    cores   = number
    sockets = optional(number)
    type    = optional(string)
    numa    = optional(bool)
  })

  default = {
    cores = 2
  }
}

locals {
  cpu = defaults(var.cpu, {
    type    = "host"
    sockets = 1
    numa    = false
  })
}

variable "agent_enabled" {
  description = <<-EOT
  Whether to expect the guest agent to be installed on the VM; default true
  See the proxmox documentation for more information.
  EOT

  type    = bool
  default = true
}

variable "memory" {
  description = <<-EOT
  The memory configuration for each VM.
  See the proxmox documentation for more information.

  * megabytes - Pretty obvious; default 1024 MB
  * balloon - Minimum memory to allocate to the VM; default memory.megabytes (no balloon)
  EOT

  type = object({
    megabytes = number
    balloon   = optional(number)
  })

  default = {
    megabytes = 1024
  }
}

locals {
  memory = defaults(var.memory, {
    balloon = var.memory.megabytes
  })
}

variable "network" {
  description = <<-EOT
  The network configuration for each VM.
  See the proxmox documentation for more information.

  * driver - The network driver to use in the VM; default "virtio"
  * bridge - The name of the proxmox bridge to attach the device to
  * cidr - The CIDR block of the network the device is attached to
  * subnet_cidr - The CIDR block for allocating IP addresses for each VM
  * base_index - The index into the CIDR block to allocate to first VM; increments to node_count; default 0
  * gateway - The gateway IP on the network
  EOT

  type = object({
    driver      = optional(string)
    bridge      = string
    cidr        = string
    subnet_cidr = string
    base_index  = optional(number)
    gateway     = string
  })
}

locals {
  network = defaults(var.network, {
    driver     = "virtio"
    base_index = 0
  })
}

variable "root_disk" {
  description = <<-EOT
  The root disk configuration for each VM.
  See the proxmox documentation for more information.

  * size - Size of the volume
  * storage - The proxmox storage pool to create the volume in
  EOT

  type = object({
    size    = string
    storage = string
  })
}

variable "extra_disks" {
  description = <<-EOT
  A list of extra volumes to create and attach to the VM. Default empty.
  See the proxmox documentation for more information.

  * size - Size of the volume
  * storage - The proxmox storage pool to create the volume in
  EOT

  type = list(object({
    size        = string
    storage     = string
    label       = string
    device      = string
    mount_point = string
  }))

  default = []
}

variable "ssh" {
  description = <<-EOT
  The SSH connection information for the VMs. This is used by k0sctl in the cluster module.
  If used, the cluster-ssh module can be supplied since it's outputs conform to the object type.

  * user - The SSH user on the VM
  * public_key - The SSH public key to install on the VM
  EOT

  type = object({
    user       = string
    public_key = string
  })
}

variable "labels" {
  description = <<-EOT
  A list of kubernetes node labels to apply to each VM. Default empty.

  * key - The label key
  * value - The label value
  EOT

  type = list(object({
    key   = string
    value = string
  }))

  default = []
}

variable "taints" {
  description = <<-EOT
  A list of kubernetes node taints to apply to each VM. Default empty.
  See https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration for more information.

  * key - The label key
  * value - The label value
  * effect - The scheduling effect
  EOT

  type = list(object({
    key    = string
    value  = string
    effect = string
  }))

  default = []
}

variable "install_flags" {
  description = "A list of additional k0s install flags. Default empty."
  type    = list(string)
  default = []
}
