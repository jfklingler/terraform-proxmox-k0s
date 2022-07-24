output "ip_addresses" {
  value = var.control_plane.ip_addresses
}

output "external_api" {
  value = {
    address = local.external_api_address
    sans    = compact([var.dns_name, local.network.ip])
  }
}
