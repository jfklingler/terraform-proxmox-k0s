terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9.10"
    }

    proxmox-resource = {
      source  = "danitso/proxmox"
      version = "~> 0.4.4"
    }
  }
}
