provider "proxmox" {
  pm_api_url = "https://${var.proxmox_api_host}:${var.proxmox_api_port}/api2/json"

  pm_tls_insecure = var.proxmox_insecure

  pm_user     = var.proxmox_username
  pm_password = var.proxmox_password
}

provider "proxmox-resource" {
  virtual_environment {
    endpoint = "https://${var.proxmox_api_host}:${var.proxmox_api_port}"
    insecure = var.proxmox_insecure

    username = var.proxmox_username
    password = var.proxmox_password
  }
}
