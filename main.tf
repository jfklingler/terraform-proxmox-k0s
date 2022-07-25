resource "null_resource" "k0sctl_apply" {
  triggers = {
    on_version_change = local.k0sctl.version
    on_config_change  = data.local_file.k0sctl_yaml.content_base64
  }

  depends_on = [
    null_resource.k0sctl_executable,
    data.local_file.k0sctl_yaml,
  ]

  provisioner "local-exec" {
    command = "${local.k0sctl_exe_path} apply ${local.telemetry_flag} --config ${local.k0sctl_config_path}"
  }
}
