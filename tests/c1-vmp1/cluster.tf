module "ssh" {
  source = "../../modules/cluster-ssh"

  worker = {
    user = "devops"
  }
}

module "control_plane" {
  source = "../../modules/control-plane"

  pve = {
    node = "pve1n01"
  }

  os = {
    template = "vm-sources:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  }

  network = {
    bridge      = "vmbr0"
    cidr        = "192.168.16.0/22"
    subnet_cidr = "192.168.18.0/23"
    gateway     = "192.168.16.1"
  }

  root_disk = {
    storage = "vms"
  }

  ssh = module.ssh.controller
}

module "worker_pool" {
  source = "../../modules/worker-pool-vm"

  pve = {
    node = "pve1n01"
  }

  os = {
    template = "ubuntu2004-templ"
    storage = {
      cdrom   = "vms"
      snippet = "snippets"
    }
  }

  network = {
    bridge      = "vmbr0"
    cidr        = "192.168.16.0/22"
    subnet_cidr = "192.168.18.0/23"
    base_index  = 1
    gateway     = "192.168.16.1"
  }

  root_disk = {
    storage = "vms"
    size    = "10G"
  }

  labels = [
    { key = "foo", value = "bar" },
    { key = "bar", value = "baz" },
  ]

  taints = [
    { key = "foo", value = "bar", effect = "NoSchedule" },
    { key = "bar", value = "baz", effect = "NoExecute" },
  ]

  install_flags = [
    "--profile=default"
  ]

  ssh = module.ssh.worker
}

module "cluster" {
  source = "../../"

  local_storage = "${abspath(path.module)}/generated"

  k0sctl = {
    version     = "v0.13.1"
    k0s_version = "v1.24.2+k0s.0"
  }

  pod_cidr     = "10.244.0.0/16"
  service_cidr = "10.96.0.0/12"

  control_plane = module.control_plane

  worker_pools = [
    module.worker_pool,
  ]

  ssh = module.ssh
}
