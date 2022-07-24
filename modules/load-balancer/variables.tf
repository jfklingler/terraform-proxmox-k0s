variable "cluster_name" {
  type    = string
  default = "default"
}

variable "pve" {
  type = object({
    node = string
    pool = optional(string)
    vmid = optional(number)
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
    megabytes = 512
  }
}

locals {
  memory = defaults(var.memory, {
    swap = 512
  })
}

variable "network" {
  type = object({
    name    = optional(string)
    bridge  = string
    cidr    = string
    ip      = string
    gateway = string
  })
}

locals {
  network = defaults(var.network, {
    name = "eth0"
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

variable "ssh" {
  type = object({
    user        = string
    public_key  = string
    private_key = optional(string)
  })
}

variable "control_plane" {
  type = object({
    ip_addresses = list(string)
  })
}

variable "dns_name" {
  description = "The DNS name assigned to this node's IP address"
  type        = string
  default     = null
}

variable "stats" {
  type = object({
    enabled = bool
  })

  default = {
    enabled = true
  }
}
