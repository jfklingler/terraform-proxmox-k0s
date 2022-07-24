locals {
  generate_controller_private_key = local.controller.private_key == null && local.controller.gen_key
  controller_private_key_present  = local.generate_controller_private_key || local.controller.private_key != null
  generate_controller_public_key  = local.controller_private_key_present && local.controller.public_key == null

  generate_worker_private_key = local.worker.private_key == null && local.worker.gen_key
  worker_private_key_present  = local.generate_worker_private_key || local.worker.private_key != null
  generate_worker_public_key  = local.worker_private_key_present && local.worker.public_key == null
}

resource "tls_private_key" "controller" {
  for_each = toset(local.generate_controller_private_key ? ["default"] : [])

  algorithm = "ED25519"
}

data "tls_public_key" "controller" {
  for_each = toset(local.generate_controller_public_key ? ["default"] : [])

  private_key_openssh = local.controller_private_key
}

resource "tls_private_key" "worker" {
  for_each = toset(local.generate_worker_private_key ? ["default"] : [])

  algorithm = "ED25519"
}

data "tls_public_key" "worker" {
  for_each = toset(local.generate_worker_public_key ? ["default"] : [])

  private_key_openssh = local.worker_private_key
}

locals {
  controller_private_key = local.generate_controller_private_key ? tls_private_key.controller["default"].private_key_openssh : local.controller.private_key
  controller_public_key  = local.generate_controller_public_key ? data.tls_public_key.controller["default"].public_key_openssh : local.controller.public_key

  worker_private_key = local.generate_worker_private_key ? tls_private_key.worker["default"].private_key_openssh : local.worker.private_key
  worker_public_key  = local.generate_worker_public_key ? data.tls_public_key.worker["default"].public_key_openssh : local.worker.public_key
}
