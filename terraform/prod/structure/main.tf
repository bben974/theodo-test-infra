terraform {
   backend "s3" {
      bucket = "terraform-theodo-test-tfstate"
      key    = "terraform-cloud-structure.tfstate"
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

## CREATE SSH KEY 
resource "openstack_compute_keypair_v2" "share_ssh_keys_prod" {
  name = "theodo_test_ssh_key_prod"
  public_key = file("${var.path_ssh_pub}")   
  region = var.region_name
}
