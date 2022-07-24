variable "controller" {
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
    gen_key = true
  })
}

variable "worker" {
  type = object({
    user        = optional(string)
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
