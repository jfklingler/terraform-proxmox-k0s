module "ssh" {
  source = "../../modules/cluster-ssh"

  worker = {
    user = "devops"
  }
}

locals {
  nodes = ["pve1n01", "pve1n02"]
}

module "control_plane_1" {
  source = "../../modules/control-plane"

  name       = "n01"
  node_count = 2

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
    base_index  = 1
    gateway     = "192.168.16.1"
  }

  root_disk = {
    storage = "vms"
  }

  ssh = module.ssh.controller
}

module "control_plane_2" {
  source = "../../modules/control-plane"

  name       = "n02"
  node_count = 1

  pve = {
    node = "pve1n02"
  }

  os = {
    template = "vm-sources:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  }

  network = {
    bridge      = "vmbr0"
    cidr        = "192.168.16.0/22"
    subnet_cidr = "192.168.18.0/23"
    # control_plane_1 base_index + node_count
    base_index  = 1 + 2
    gateway     = "192.168.16.1"
  }

  root_disk = {
    storage = "vms"
  }

  ssh = module.ssh.controller
}

module "load_balancer" {
  source = "../../modules/load-balancer"

  pve = {
    node = "pve1n01"
  }

  os = {
    template = "vm-sources:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  }

  network = {
    bridge  = "vmbr0"
    cidr    = "192.168.16.0/22"
    ip      = "192.168.18.0"
    gateway = "192.168.16.1"
  }

  root_disk = {
    storage = "vms"
  }

  control_plane = [
    module.control_plane_1,
    module.control_plane_2,
  ]

  ssh = module.ssh.controller
}

module "worker_pool_1" {
  source = "../../modules/worker-pool-vm"

  name       = "pool1"
  node_count = 2

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
    base_index  = 4
    gateway     = "192.168.16.1"
  }

  root_disk = {
    storage = "vms"
    size    = "10G"
  }

  labels = [
    { key = "foo", value = "bar" },
  ]

  ssh = module.ssh.worker
}

module "worker_pool_2" {
  source = "../../modules/worker-pool-vm"

  name       = "pool2"
  node_count = 2

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
    base_index  = 6
    gateway     = "192.168.16.1"
  }

  root_disk = {
    storage = "vms"
    size    = "10G"
  }

  labels = [
    { key = "bar", value = "baz" },
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

  control_plane = module.load_balancer

  worker_pools = [
    module.worker_pool_1,
    module.worker_pool_2,
  ]

  ssh = module.ssh
}
