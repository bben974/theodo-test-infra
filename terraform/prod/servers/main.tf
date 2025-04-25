terraform {
   backend "s3" {
      bucket = "terraform-theodo-test-tfstate"
      key    = "terraform-servers-structure.tfstate"
      region = "gra"
      endpoints = {
        s3 = "https://s3.gra.io.cloud.ovh.net"
      } 
      skip_credentials_validation = true
      skip_region_validation = true
      skip_metadata_api_check = true
      skip_s3_checksum = true
      skip_requesting_account_id = true
  }
}

data "terraform_remote_state" "cloud_structure" {
  backend = "s3"
  config = {
      bucket = "terraform-theodo-test-tfstate"
      key    = "terraform-structure.tfstate"
      region = "gra"
      endpoints = {
        s3 = "https://s3.gra.io.cloud.ovh.net"
      } 
      skip_credentials_validation = true
      skip_region_validation = true
      skip_metadata_api_check = true
      skip_s3_checksum = true
      skip_requesting_account_id = true
  }
}

provider "openstack" {
  auth_url    = "https://auth.cloud.ovh.net/v3/" # Authentication URL
  domain_name = "default"                        # Domain name - Always at 'default' for OVHcloud
}

### postgres_secgroup - Access PostgreSQL
resource "openstack_networking_secgroup_v2" "postgres_secgroup" {
  name        = "postgres_secgroup"
  description = "Security group for connection postgres"
  region      = var.region_name
}

### rule port 5432 for postgresql
resource "openstack_networking_secgroup_rule_v2" "postgres_secgroup_rule_all_net" {
  region            = openstack_networking_secgroup_v2.postgres_secgroup.region
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_ip_prefix  = var.ext_net
  security_group_id = openstack_networking_secgroup_v2.postgres_secgroup.id
}

### rule port 22 for ssh connection
resource "openstack_networking_secgroup_rule_v2" "postgres_secgroup_rule_ssh" {
  region            = openstack_networking_secgroup_v2.postgres_secgroup.region
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.ext_net
  security_group_id = openstack_networking_secgroup_v2.postgres_secgroup.id
}

module "basic_postgresql" {
  source              = "../../modules/basic-instance"
  region              = var.region_name
  machine_type        = "d2-2"
  key_pair_name       = data.terraform_remote_state.cloud_structure.outputs.ssh_prod_name
  security_group      = "postgres_secgroup"
  instance_name       = "basic_postgres"
  metadata            = {
                          env = "prod"
                          app = "db"
                        }
  ansible_playbook    = "../ansible/postgresql-deploy.yml"
}