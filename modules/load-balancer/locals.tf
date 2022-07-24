locals {
  external_api_address = coalesce(var.dns_name, local.network.ip)
}
