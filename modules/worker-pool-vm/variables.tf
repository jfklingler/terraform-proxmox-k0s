variable "cluster_name" {
  type    = string
  default = "default"
}

variable "name" {
  type    = string
  default = "default"
}

variable "node_count" {
  type    = number
  default = 1
}

variable "pve" {
  type = object({
    node      = string
    pool      = optional(string)
    base_vmid = optional(number)
  })
}

variable "os" {
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
  type    = bool
  default = true
}

variable "memory" {
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
  type = object({
    size    = string
    storage = string
  })
}

variable "extra_disks" {
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
  type = object({
    user       = string
    public_key = string
  })
}

variable "labels" {
  type = list(object({
    key   = string
    value = string
  }))

  default = []
}

variable "taints" {
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))

  default = []
}

variable "install_flags" {
  type    = list(string)
  default = []
}
