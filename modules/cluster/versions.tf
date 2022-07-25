terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }

  required_version = ">= 1.0.0"

  experiments = [module_variable_optional_attrs]
}
