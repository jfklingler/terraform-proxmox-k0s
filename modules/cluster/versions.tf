terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }

  experiments = [module_variable_optional_attrs]
}
