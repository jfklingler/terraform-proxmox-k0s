# Cluster SSH Configuration

This module is designed to be a convenience.
The primary use for this module, while utilizing the key genreation feature, is for testing and for homelab environments where, typically, the operator is the only administrative user.

## Caution

The [primary module](../../) requires SSH private keys either on disk or in the SSH agent on the machine running terraform.
If the SSH agent is not used, the private keys must written to disk because the [k0sctl](https://github.com/k0sproject/k0sctl) config file only accepts private key paths.
*The private keys should not, under any circumstances, be committed to source control.*
See the [primary module](../../) documentation for details.

## Alternatives

Any module which is designed to accept the output of this module will also accept an externally defined object conforming to the structure below.

```hcl
{
  user        # string; user name for SSH connection
  private_key # string; private key contents; not required if SSH agent will be used
  public_key  # string; public key contents
  use_agent   # bool; whether or not the SSH agent will be used by k0sctl to connect to VMs
}
```

The `private_key` field is only required if the SSH agent will not be used.
This field is only required by the `cluster` (for `k0sctl` config) and `load-balancer` (for provisioning) modules.

The `public_key` field is only required by modules that create virtual machines; `control-plane`, `worker-pool-vm`, etc.
This field is only required by the `cluster` (for `k0sctl` config) and `load-balancer` (for provisioning) modules.
