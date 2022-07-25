variable "controller" {
  description = <<-EOT
  The SSH connection details for the control plane components.
  
  * user - The user name to connect with; default "root"
  * private_key - The private key content; if not specified and gen_key is false, a private key is generated
  * public_key - The public key content; required if private key is not generated and gen_key is false
  * gen_key - Whether to generate a private/public key if not supplied; default true public key not specified; set to false if SSH agent will be used

  CAUTION: The private key will be written to disk on the host running terraform because k0sctl requires either a file path or use of the SSH agent.
  EOT

  type = object({
    user        = string
    private_key = optional(string)
    public_key  = optional(string)
    gen_key     = optional(bool)
  })

  default = {
    user = "root"
  }
}

locals {
  controller = defaults(var.controller, {
    gen_key = var.controller.public_key == null
  })
}

variable "worker" {
  description = <<-EOT
  The SSH connection details for the worker components.
  
  * user - The user name to connect with; default "root"
  * private_key - The private key content; if not specified and gen_key is false, a private key is generated
  * public_key - The public key content; required if private key is not generated and gen_key is false
  * gen_key - Whether to generate a private/public key if not supplied; default true public key not specified; set to false if SSH agent will be used

  CAUTION: The private key will be written to disk on the host running terraform because k0sctl requires either a file path or use of the SSH agent.
  EOT

  type = object({
    user        = string
    private_key = optional(string)
    public_key  = optional(string)
    gen_key     = optional(bool)
  })

  default = {
    user = "root"
  }
}

locals {
  worker = defaults(var.worker, {
    gen_key = true
  })
}
