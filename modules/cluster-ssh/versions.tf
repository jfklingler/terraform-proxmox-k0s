terraform {
  required_providers {
    tls = {
      source = "hashicorp/tls"
    }
  }

  experiments = [module_variable_optional_attrs]
}
