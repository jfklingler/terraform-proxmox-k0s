output "controller" {
  description = <<-EOT
  The SSH connection details for the control plane components.
  
  * user - The user name to connect with
  * private_key - The private key content; null if not generated or specified as an input
  * public_key - The public key content
  * use_agent - Whether the SSH agent will be used by k0sctl to connect to VMs

  CAUTION: The private key contents, if specified or generated, will be written to disk on the host running terraform because k0sctl requires either a file path or use of the SSH agent.
  EOT

  value = {
    user        = local.controller.user
    private_key = local.controller_private_key
    public_key  = local.controller_public_key
    use_agent   = !local.controller_private_key_present
  }

  sensitive = true
}

output "worker" {
  description = <<-EOT
  The SSH connection details for the worker components.
  
  * user - The user name to connect with
  * private_key - The private key content; null if not generated or specified as an input
  * public_key - The public key content
  * use_agent - Whether the SSH agent will be used by k0sctl to connect to VMs

  CAUTION: The private key contents, if specified or generated, will be written to disk on the host running terraform because k0sctl requires either a file path or use of the SSH agent.
  EOT

  value = {
    user        = local.worker.user
    private_key = local.worker_private_key
    public_key  = local.worker_public_key
    use_agent   = !local.controller_private_key_present
  }

  sensitive = true
}
