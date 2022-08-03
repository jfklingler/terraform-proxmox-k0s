output "ip_addresses" {
  description = "The IP addresses of the containers created by this module"

  value = [for i in range(var.node_count) : cidrhost(local.network.subnet_cidr, local.network.base_index + i)]
}
