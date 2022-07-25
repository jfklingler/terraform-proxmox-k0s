terraform {
  required_providers {
    tls = {
      source = "hashicorp/tls"
    }
  }

  required_version = ">= 1.0.0"

  experiments = [module_variable_optional_attrs]
}
