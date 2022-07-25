terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }

    proxmox-resource = {
      source = "danitso/proxmox"
    }
  }

  version = ">= 1.0.0"

  experiments = [module_variable_optional_attrs]
}
