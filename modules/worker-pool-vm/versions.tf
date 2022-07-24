terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }

    proxmox-resource = {
      source = "danitso/proxmox"
    }
  }

  experiments = [module_variable_optional_attrs]
}
