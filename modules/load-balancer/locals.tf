locals {
  ip_addresses = concat([for cp in var.control_plane : cp.ip_addresses])
  external_api_address = coalesce(var.dns_name, local.network.ip)
}
