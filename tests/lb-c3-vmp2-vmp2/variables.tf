variable "proxmox_api_host" {
  description = "Used to configure terraform providers"
  type        = string
}

variable "proxmox_api_port" {
  description = "Used to configure terraform providers"
  type        = number
}

variable "proxmox_insecure" {
  description = "Used to configure terraform providers"
  type        = bool
}

variable "proxmox_username" {
  description = "Used to configure terraform providers"
  type        = string
}

variable "proxmox_password" {
  description = "Used to configure terraform providers"
  type        = string
  sensitive   = true
}
