output "k0sctl_config" {
  value = data.local_file.k0sctl_yaml.content
}

output "kube_config" {
  value     = data.local_sensitive_file.kube_config.content
  sensitive = true
}
