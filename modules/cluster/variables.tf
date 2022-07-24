variable "name" {
  type    = string
  default = "default"
}

variable "local_storage" {
  type = string
}

variable "k0sctl" {
  type = object({
    version     = string
    k0s_version = string
    k0s_binary  = optional(string)
    telemetry   = optional(bool)
  })
}

locals {
  k0sctl = defaults(var.k0sctl, {
    telemetry = false
  })
}

variable "ssh" {
  type = object({
    controller = object({
      user        = string
      private_key = optional(string)
      use_agent   = bool
    })

    worker = object({
      user        = string
      private_key = optional(string)
      use_agent   = bool
    })
  })
}

variable "control_plane" {
  type = object({
    ip_addresses = list(string)
    external_api = optional(object({
      address = string
      sans    = list(string)
    }))
  })
}

variable "worker_pools" {
  type = list(object({
    ip_addresses = list(string)
    labels = list(object({
      key   = string
      value = string
    }))
    taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
    install_flags = list(string)
  }))
}

variable "pod_cidr" {
  type = string
}

variable "service_cidr" {
  type = string
}
