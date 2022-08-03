output "ip_addresses" {
  description = "The IP addresses of the containers in the control_plane pool"

  value = var.control_plane.ip_addresses
}

output "external_api" {
  description = <<-EOT
  The external (kubectl) control plane address

  * address - The IP address of the load balancer container
  * sans - The names on the control plane node certificates
  EOT

  value = {
    address = local.external_api_address
    sans    = compact([var.dns_name, local.network.ip])
  }
}
