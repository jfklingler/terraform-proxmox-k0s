locals {
  hotplug = concat(["disk", "network", "usb"], local.cpu.numa ? ["memory", "cpu"] : [])
}

resource "proxmox_vm_qemu" "k0s_node" {
  count = var.node_count

  desc = <<-EOT
    <h2>k0s Worker Node</h2>
    <p>
    <strong>Cluster:</strong> ${var.cluster_name}</br>
    <strong>Pool:</strong> ${var.name}</br>
    <strong>Index:</strong> ${count.index}</br>
    </p>
    </hr>
    <em>Managed by Terraform</em>
  EOT

  name = "k0s-${var.cluster_name}-${var.name}-${count.index}"

  pool        = var.pve.pool
  target_node = var.pve.node
  vmid        = try(var.pve.base_vmid + count.index, null)

  clone                   = local.os.template
  full_clone              = !local.os.linked
  os_type                 = "cloud-init"
  cicustom                = "user=${proxmox_virtual_environment_file.cloud_init[count.index].id}"
  cloudinit_cdrom_storage = local.os.storage.cdrom
  ciuser                  = var.ssh.user
  sshkeys                 = var.ssh.public_key

  agent = var.agent_enabled ? 1 : 0

  cpu     = local.cpu.type
  cores   = local.cpu.cores
  sockets = local.cpu.sockets
  numa    = local.cpu.numa
  memory  = local.memory.megabytes
  balloon = local.memory.balloon
  hotplug = join(",", local.hotplug)
  onboot  = true

  vga {
    memory = 0
    type   = "serial0"
  }

  serial {
    id   = 0
    type = "socket"
  }

  ipconfig0 = "ip=${cidrhost(local.network.subnet_cidr, local.network.base_index + count.index)}/${split("/", local.network.cidr)[1]},gw=${local.network.gateway}"

  network {
    model  = local.network.driver
    bridge = local.network.bridge
  }

  scsihw = "virtio-scsi-pci"
  boot   = "c"

  disk {
    size    = var.root_disk.size
    storage = var.root_disk.storage
    type    = "scsi"
    format  = "raw"
    discard = "on"
  }

  dynamic "disk" {
    for_each = var.extra_disks

    content {
      size    = disk.value.size
      storage = disk.value.storage
      type    = "scsi"
      format  = "raw"
      discard = "on"
    }
  }
}
