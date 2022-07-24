resource "proxmox_virtual_environment_file" "cloud_init" {
  count    = var.node_count
  provider = proxmox-resource

  content_type = "snippets"
  datastore_id = local.os.storage.snippet
  node_name    = var.pve.node

  source_raw {
    file_name = "k0s-${var.cluster_name}-${var.name}-${count.index}-cloud-init.yaml"
    data = templatefile("${path.module}/templates/cloud-init.yaml.tftpl", {
      hostname    = "k0s-${var.cluster_name}-${var.name}-${count.index}"
      upgrade     = local.os.upgrade
      ssh_user    = var.ssh.user
      ssh_key     = var.ssh.public_key
      extra_disks = var.extra_disks
    })
  }
}
