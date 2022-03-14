# Define required providers
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}
# Configure the OpenStack provider
provider "openstack" {
  user_name   = var.openstack_user_name
  tenant_name = var.openstack_tenant_name
  password    = var.openstack_password
  auth_url    = var.openstack_auth_url
  region      = var.openstack_region
  domain_name = "ADS"
}

# Cloud cluster
module "cloud_cluster" {
  source                            = "./modules/cluster"
  cluster_name                      = var.cluster_name
  worker_count                      = var.worker_count
  master_count                      = var.master_count
  edge_count                        = var.edge_count
  instance_image_id                 = var.instance_image_id
  instance_flavor_name              = var.instance_flavor_name
  instance_keypair_name             = var.instance_keypair_name
  instance_block_device_volume_size = var.instance_block_device_volume_size
  ssh_key_file                      = var.ssh_key_file
  floatingip_pool                   = var.floatingip_pool
  public_network_name               = var.public_network_name
  subnet_cidr                       = var.subnet_cidr
  pod_subnet                        = var.pod_subnet
  keadm_version                     = var.keadm_version
  keadm_host_os                     = var.keadm_host_os
}
