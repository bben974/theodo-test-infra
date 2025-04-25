output "hosts_ip" {
  value = openstack_compute_instance_v2.instance.network.1.fixed_ip_v4
}

output "hosts_name" {
  value = openstack_compute_instance_v2.instance.name
}