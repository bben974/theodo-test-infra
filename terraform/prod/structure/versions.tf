terraform {
  required_version = ">= 0.14.0"
  required_providers {
    ovh = {
      source = "ovh/ovh"
    }
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "~> 1.48.0"
    }
  }
}
