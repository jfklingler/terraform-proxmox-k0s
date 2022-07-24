output "ip_addresses" {
  value = [for i in range(var.node_count) : cidrhost(local.network.subnet_cidr, local.network.base_index + i)]
}
