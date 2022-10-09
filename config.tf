locals {
  k0sctl_exe_path    = "${var.local_storage}/k0sctl"
  k0sctl_config_path = "${var.local_storage}/k0sctl.yaml"
  kube_config_path   = "${var.local_storage}/kube-config"

  telemetry_flag = local.k0sctl.telemetry ? "" : "--disable-telemetry"

  worker_pools = [for pool in var.worker_pools : {
    ip_addresses = pool.ip_addresses
    install_flags = flatten([
      pool.labels == [] ? [] : ["--labels=\"${join(",", [for v in pool.labels : "${trimspace(v.key)}=${trimspace(v.value)}"])}\""],
      pool.taints == [] ? [] : ["--taints=\"${join(",", [for v in pool.taints : "${trimspace(v.key)}=${trimspace(v.value)}:${trimspace(v.effect)}"])}\""],
      [for v in pool.install_flags : trimspace(v)]
    ])
  }]
}

resource "local_file" "k0sctl_yaml" {
  filename = local.k0sctl_config_path
  content = templatefile("${path.module}/templates/k0sctl.yaml.tftpl", {
    binary_path = local.k0sctl.k0s_binary

    controller_ips       = var.control_plane.ip_addresses
    controller_user      = var.ssh.controller.user
    controller_use_agent = var.ssh.controller.use_agent
    controller_ssh_key   = var.ssh.controller.use_agent ? "" : local_sensitive_file.controller_ssh_pk[0].filename

    worker_pools     = local.worker_pools
    worker_user      = var.ssh.worker.user
    worker_use_agent = var.ssh.worker.use_agent
    worker_ssh_key   = var.ssh.controller.use_agent ? "" : local_sensitive_file.worker_ssh_pk[0].filename

    cluster_name = var.name
    k0s_version  = local.k0sctl.k0s_version
    api_sans     = try(distinct(var.control_plane.external_api.sans), [])
    api_address  = try(var.control_plane.external_api.address, "")
    pod_cidr     = var.pod_cidr
    service_cidr = var.service_cidr
  })
}

data "local_file" "k0sctl_yaml" {
  filename = local.k0sctl_config_path

  depends_on = [
    local_file.k0sctl_yaml,
  ]
}

resource "null_resource" "k0sctl_executable" {
  triggers = {
    on_version_change = local.k0sctl.version
  }

  provisioner "local-exec" {
    command = "wget -O ${local.k0sctl_exe_path} https://github.com/k0sproject/k0sctl/releases/download/${local.k0sctl.version}/k0sctl-linux-x64 && chmod +x ${local.k0sctl_exe_path}"
  }

  # │ Error: Invalid reference from destroy provisioner
  # │ 
  # │   on ../../modules/cluster/config.tf line 53, in resource "null_resource" "k0sctl_executable":
  # │   53:     working_dir = var.local_storage
  # │ 
  # │ Destroy-time provisioners and their connection configurations may only reference attributes of the related resource, via 'self', 'count.index', or 'each.key'.
  # │ 
  # │ References to other resources during the destroy phase can cause dependency cycles and interact poorly with create_before_destroy.
  #   provisioner "local-exec" {
  #     when        = destroy
  #     working_dir = var.local_storage
  #     command     = "if [ -f ./k0sctl ]; then rm ./k0sctl; fi"
  #   }
}

resource "null_resource" "kube_config" {
  triggers = {
    on_version_change = local.k0sctl.version
    on_config_change  = data.local_file.k0sctl_yaml.content_base64
  }

  depends_on = [
    null_resource.k0sctl_executable,
    data.local_file.k0sctl_yaml,
    null_resource.k0sctl_apply,
  ]

  provisioner "local-exec" {
    command = "${local.k0sctl_exe_path} kubeconfig ${local.telemetry_flag} --config ${local.k0sctl_config_path} > ${local.kube_config_path}"
  }

  # │ Error: Invalid reference from destroy provisioner
  # │ 
  # │   on ../../modules/cluster/config.tf line 76, in resource "null_resource" "kube_config":
  # │   76:     working_dir = var.local_storage
  # │ 
  # │ Destroy-time provisioners and their connection configurations may only reference attributes of the related resource, via 'self', 'count.index', or 'each.key'.
  # │ 
  # │ References to other resources during the destroy phase can cause dependency cycles and interact poorly with create_before_destroy.
  #   provisioner "local-exec" {
  #     when        = destroy
  #     working_dir = var.local_storage
  #     command     = "if [ -f ./kube-config ]; then rm ./kube-config; fi"
  #   }
}

data "local_sensitive_file" "kube_config" {
  filename = local.kube_config_path

  depends_on = [
    null_resource.kube_config,
  ]
}
