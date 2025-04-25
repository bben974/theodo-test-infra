data "openstack_networking_network_v2" "ext_net" {
  name = "Ext-Net"
}

data "openstack_networking_secgroup_v2" "secgroup" {
  name = var.security_group
}

### Creating a public network access
resource "openstack_networking_port_v2" "public" {
  name           = "${var.instance_name}-public"
  network_id     = data.openstack_networking_network_v2.ext_net.id
  security_group_ids = [
    data.openstack_networking_secgroup_v2.secgroup.id
  ]
  admin_state_up = "true"
}

## Creating server with a public network access
resource "openstack_compute_instance_v2" "instance" {
  name = var.instance_name
  image_name = var.image_name
  flavor_name = var.machine_type
  region = var.region
  key_pair = var.key_pair_name

  network {
    port = openstack_networking_port_v2.public.id
  }

  metadata = var.metadata

}


### run ansible to configure the server if the ansible_playbook is filled
resource "null_resource" "ansible_configuration" {
  
  count = var.ansible_playbook == "" ? 0 : 1

  provisioner "local-exec" {
      command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u debian -i '${openstack_compute_instance_v2.instance.network.1.fixed_ip_v4},' ${var.ansible_playbook}"
  }
  
}