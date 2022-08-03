output "k0sctl_config" {
  description = "The generated k0sctl config file contents for this cluster"

  value = data.local_file.k0sctl_yaml.content
}

output "kube_config" {
  description = "The kubernetes config file context for this cluster"

  value     = data.local_sensitive_file.kube_config.content
  sensitive = true
}
