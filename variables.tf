variable "name" {
  description = "The name of the k0s cluster; informational; used in proxmox resource names"

  type    = string
  default = "default"
}

variable "local_storage" {
  description = <<-EOT
  The directory in which to write out necessary files (k0sctl binary, k0sctl config, kube config, etc.).
  For example 'local_storage = "$${abspath(path.module)}/generated-files"'.
  It is recommended to gitignore this directory if the parent directory is under source control."
  EOT

  type = string
}

variable "k0sctl" {
  description = <<-EOT
  The k0sctl configuration for this cluster.

  * version - The k0sctl version to use
  * k0s_version - The k0s version to be downloaded and installed
  * k0s_binary - Local path to a k0s binary to upload instead of downloading on each node
  * telemetry - Whether k0s/k0sctl telemetry is enabled; default false
  EOT

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
  description = <<-EOT
  The SSH configuration used by k0sctl for node setup.
  An instance of the cluster-ssh module can be used here, e.g. 'module.my_ssh_config'.
  Alternatively, a custom object may be defined with the required values.

  * contoller - SSH configuration for control plane nodes
    * user - The user name to connect with
    * private_key - The private key content; may be null if SSH agent will be used
    * use_agent - Whether the SSH agent will be used by k0sctl to connect to VMs
  * worker - SSH configuration for worker plane nodes
    * user - The user name to connect with
    * private_key - The private key content; may be null if SSH agent will be used
    * use_agent - Whether the SSH agent will be used by k0sctl to connect to VMs
  EOT

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
  description = <<-EOT
  The control plane configuration for the cluster.
  This should be either an instance of the control-plane module or an instance of the load-balancer module.
  EOT

  type = object({
    ip_addresses = list(string)
    external_api = optional(object({
      address = string
      sans    = list(string)
    }))
  })
}

variable "worker_pools" {
  description = <<-EOT
  The worker pool configurations for the cluster.
  These should be instances of the worker-pool-vm module.
  EOT

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
  description = "The CIDR block from which pod IP addresses will be assigned"
  
  type = string
}

variable "service_cidr" {
  description = "The CIDR block from which service IP addresses will be assigned"

  type = string
}
