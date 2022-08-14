variable "cluster_name" {
  description = "The name of the k0s cluster; used in proxmox resources and VM hostnames"

  type    = string
  default = "default"
}

variable "name" {
  description = "The name of the controller pool; used in proxmox resources and VM hostnames"

  type    = string
  default = null
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

  * template - The container template to clone
  * linked - Whether to create a linked clone; default true
  * type - The OS type, when autodetection fails; default unspecified
  EOT

  type = object({
    template = string
    linked   = optional(bool)
    type     = optional(string)
  })
}

locals {
  os = defaults(var.os, {
    linked = true
  })
}

variable "node_count" {
  description = "How many VMs to create. Should be an odd number in most cases. Default 1."

  type    = number
  default = 1
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

variable "cpu" {
  description = <<-EOT
  The CPU configuration for each VM.
  See the proxmox documentation for more information.

  * cores - The number of cores to allocate; default 2
  * limit - The CPU (core) limit for the VM; optional
  * units - The core weight for the VM; optional
  EOT

  type = object({
    cores = number
    limit = optional(number)
    units = optional(number)
  })

  default = {
    cores = 2
  }
}

locals {
  cpu = defaults(var.cpu, {
    limit = var.cpu.cores
    units = 1024
  })
}

variable "memory" {
  description = <<-EOT
  The memory configuration for each VM.
  See the proxmox documentation for more information.

  * megabytes - Pretty obvious; default 1024 MB
  * swap - How much swap space to allocate; default 512 MB
  EOT

  type = object({
    megabytes = number
    swap      = optional(number)
  })

  default = {
    megabytes = 1024
  }
}

locals {
  memory = defaults(var.memory, {
    swap = 512
  })
}

variable "network" {
  description = <<-EOT
  The network configuration for each VM.
  See the proxmox documentation for more information.

  * name - The name of the ethernet device in the VM; default "eth0"
  * bridge - The name of the proxmox bridge to attach the device to
  * cidr - The CIDR block of the network the device is attached to
  * subnet_cidr - The CIDR block for allocating IP addresses for each VM
  * base_index - The index into the CIDR block to allocate to first VM; increments to node_count; default 0
  * gateway - The gateway IP on the network
  EOT

  type = object({
    name        = optional(string)
    bridge      = string
    cidr        = string
    subnet_cidr = string
    base_index  = optional(number)
    gateway     = string
  })
}

locals {
  network = defaults(var.network, {
    name       = "eth0"
    base_index = 0
  })
}

variable "root_disk" {
  description = <<-EOT
  The root disk configuration for each VM
  See the proxmox documentation for more information.

  * size - Size of the volume; default "10G"
  * storage - The proxmox storage pool to create the volume in
  EOT

  type = object({
    size    = optional(string)
    storage = string
  })
}

locals {
  root_disk = defaults(var.root_disk, {
    size = "10G"
  })
}

variable "ha" {
  description = <<-EOT
  The high availability configuration for each VM
  See the proxmox documentation for more information.

  * state - The desired HA state; default "ignored"
  * group - The HA group the VM will participate in; required if state is not "ignored"
  EOT

  type = object({
    state = string
    group = string
  })

  default = {
    state = "ignored"
    group = null
  }
}
