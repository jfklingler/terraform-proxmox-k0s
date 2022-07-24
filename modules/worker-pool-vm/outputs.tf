output "ip_addresses" {
  value = [for i in range(var.node_count) : cidrhost(local.network.subnet_cidr, local.network.base_index + i)]
}

output "labels" {
  value = var.labels
}

output "taints" {
  value = var.taints
}

output "install_flags" {
  value = var.install_flags
}
