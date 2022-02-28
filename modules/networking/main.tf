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
# Create network
resource "openstack_networking_network_v2" "private_network" {
  name                  = var.private_network_name
  admin_state_up        = "true"
  port_security_enabled = "true"
}

# Create subnet
resource "openstack_networking_subnet_v2" "subnet" {
  name       = var.subnet_name
  cidr       = var.subnet_cidr
  network_id = openstack_networking_network_v2.private_network.id
  ip_version = 4
}

# Get public network info
data "openstack_networking_network_v2" "public_network" {
  name = var.public_network_name
}

# Create a router
resource "openstack_networking_router_v2" "router" {
  name                = var.router_name
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.public_network.id
}

# Give internet access to the subnet
resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}

# Create a Secutiry Group for k8s
resource "openstack_networking_secgroup_v2" "secgroup" {
  name        = var.secgroup_name
  description = var.secgroup_description
}

# Create a Secutiry Group Rules for k8s
resource "openstack_networking_secgroup_rule_v2" "secgroup_rules" {
  count = length(var.secgroup_rules)

  direction = "ingress"
  ethertype = "IPv4"

  protocol          = var.secgroup_rules[count.index].ip_protocol
  port_range_min    = var.secgroup_rules[count.index].port
  port_range_max    = var.secgroup_rules[count.index].port
  remote_ip_prefix  = var.secgroup_rules[count.index].cidr
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}
