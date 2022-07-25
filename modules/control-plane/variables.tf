variable "cluster_name" {
  type    = string
  default = "default"
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
    type     = optional(string)
  })
}

locals {
  os = defaults(var.os, {
    linked = true
  })
}

variable "node_count" {
  type    = number
  default = 1
}

variable "ssh" {
  type = object({
    user       = string
    public_key = string
  })
}

variable "cpu" {
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
  type = object({
    state = string
    group = string
  })

  default = {
    state = "ignored"
    group = null
  }
}
