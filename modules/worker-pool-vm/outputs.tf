output "ip_addresses" {
  description = "The IP addresses of the VMs in created in this pool"

  value = [for i in range(var.node_count) : cidrhost(local.network.subnet_cidr, local.network.base_index + i)]
}

output "labels" {
  description = "The kubernetes node labels applied to each node in this pool"

  value = var.labels
}

output "taints" {
  description = "The kubernetes node taints applied to each node in this pool"

  value = var.taints
}

output "install_flags" {
  description = "The k0s install flags applied to each node in this pool, not including label and taint flags"

  value = var.install_flags
}
