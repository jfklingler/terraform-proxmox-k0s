terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }

    random = {
      source = "hashicorp/random"
    }
  }

  required_version = ">= 1.0.0"

  experiments = [module_variable_optional_attrs]
}
