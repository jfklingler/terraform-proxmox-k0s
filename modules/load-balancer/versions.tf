terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }

    random = {
      source = "hashicorp/random"
    }
  }

  experiments = [module_variable_optional_attrs]
}
