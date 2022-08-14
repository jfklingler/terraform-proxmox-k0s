resource "proxmox_lxc" "controller" {
  count = var.node_count

  description = <<-EOT
    <h2>k0s Controller Node</h2>
    <p>
    <strong>Cluster:</strong> ${var.cluster_name}</br>
    <strong>Index:</strong> ${count.index}</br>
    </p>
    </hr>
    <em>Managed by Terraform</em>
  EOT

  hostname = "k0s-${var.cluster_name}-controller${var.name == null ? "" : "-${var.name}"}-${count.index}"

  ostemplate   = local.os.template
  full         = !local.os.linked
  ostype       = local.os.type
  unprivileged = true

  pool        = var.pve.pool
  target_node = var.pve.node
  vmid        = try(var.pve.base_vmid + count.index, null)
  hastate     = var.ha.state
  hagroup     = var.ha.group

  cores    = local.cpu.cores
  cpulimit = local.cpu.limit
  cpuunits = local.cpu.units
  memory   = local.memory.megabytes
  swap     = local.memory.swap

  start  = true
  onboot = true
  # startup = "order=${var.base_vmid + min(1, count.index)}"

  password        = random_password.root_password[count.index].result
  ssh_public_keys = var.ssh.public_key

  rootfs {
    storage = local.root_disk.storage
    size    = local.root_disk.size
  }

  network {
    name   = local.network.name
    bridge = local.network.bridge
    ip     = "${cidrhost(local.network.subnet_cidr, local.network.base_index + count.index)}/${split("/", local.network.cidr)[1]}"
    gw     = local.network.gateway
  }

  lifecycle {
    ignore_changes = [
      target_node,
    ]
  }
}

resource "random_password" "root_password" {
  count = var.node_count

  length           = 32
  special          = true
  override_special = "!@#$%&*-_=+"
}
