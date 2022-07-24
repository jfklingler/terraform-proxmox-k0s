output "controller" {
  value = {
    user        = local.controller.user
    private_key = local.controller_private_key
    public_key  = local.controller_public_key
    use_agent   = !local.controller_private_key_present
  }
}

output "worker" {
  value = {
    user        = local.worker.user
    private_key = local.worker_private_key
    public_key  = local.worker_public_key
    use_agent   = !local.controller_private_key_present
  }
}
