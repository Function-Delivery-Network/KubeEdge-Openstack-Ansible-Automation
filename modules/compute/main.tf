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
# Create Instances
resource "openstack_compute_instance_v2" "instance" {
  depends_on        = [var.instance_depends_on]
  count             = var.instance_count
  name              = format("%s-%s-%02d", var.cluster_name, var.instance_role, count.index + 1)
  flavor_name       = var.instance_flavor_name
  key_pair          = var.instance_keypair_name
  availability_zone = var.instance_availability_zone
  security_groups   = ["default", var.secgroup_name]
  user_data         = "#cloud-config\nhostname: ${format("%s-%s-%02d", var.cluster_name, var.instance_role, count.index + 1)}\nfqdn: ${format("%s-%s-%02d", var.cluster_name, var.instance_role, count.index + 1)}"

  block_device {
    uuid                  = var.instance_image_id
    source_type           = var.instance_block_device_source_type
    volume_size           = var.instance_block_device_volume_size
    boot_index            = var.instance_block_device_boot_index
    destination_type      = var.instance_block_device_destination_type
    delete_on_termination = var.instance_block_device_delete_on_termination
  }

  network {
    name = var.network_name
  }
}

# Create Floating IPs
resource "openstack_networking_floatingip_v2" "floatingip" {
  count = var.instance_count
  pool  = var.floatingip_pool
}

# Create Floating IP associations
resource "openstack_compute_floatingip_associate_v2" "floatingip_associate_instance" {
  count       = var.instance_count
  floating_ip = openstack_networking_floatingip_v2.floatingip[count.index].address
  instance_id = openstack_compute_instance_v2.instance[count.index].id
}

# Export the instances' data
data "null_data_source" "instances" {
  count  = var.instance_count
  inputs = {
    name        = openstack_compute_instance_v2.instance[count.index].name
    id          = openstack_compute_instance_v2.instance[count.index].id
    internal_ip = openstack_compute_instance_v2.instance[count.index].access_ip_v4
    floating_ip = openstack_networking_floatingip_v2.floatingip[count.index].address
  }
}

# resource "openstack_lb_member_v2" "member" {
#   count = var.instance_count

#   pool_id       = var.network_pool_id
#   subnet_id     = var.network_subnet_id
#   address       = openstack_compute_instance_v2.instance[count.index].access_ip_v4
#   protocol_port = 31002
# }
