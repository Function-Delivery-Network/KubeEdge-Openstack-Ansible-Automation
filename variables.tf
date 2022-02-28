variable "openstack_user_name" {}
variable "openstack_tenant_name" {}
variable "openstack_password" {}
variable "openstack_auth_url" {}
variable "openstack_project_name" {}
variable "openstack_project_id" {}
variable "openstack_user_domain_name" {}
variable "openstack_region" {}

variable "cluster_name" {
  type    = string
  default = "cloud"
}

# Network variables

variable "floatingip_pool" {
  type    = string
  default = "internet_pool"
}

variable "public_network_name" {
  type    = string
  default = "internet_pool"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

variable "pod_subnet" {
  type    = string
  default = "10.244.0.0/16"
}

# Compute Variables

variable "master_count" {
  type    = number
  default = 1
}

variable "worker_count" {
  type    = number
  default = 1
}

variable "edge_count" {
  type    = number
  default = 1
}

variable "instance_image_id" {
  type    = string
  default = "a51394b8-ffb6-4e04-a7a5-108d7ff58e52"
}

variable "instance_flavor_name" {
  type    = string
  default = "lrz.medium"
}

variable "instance_keypair_name" {
  type        = string
  default     = "kube-edge-lrz"
  description = "SSH keypair name"
}

variable "instance_block_device_volume_size" {
  type    = number
  default = 40
}

variable "ssh_key_file" {
  type    = string
  default = "~/.ssh/kube-edge-lrz.pem"
}
# keadm vars

variable "keadm_version" {
  type    = string
  default = "1.9.1"
}

variable "keadm_host_os" {
  type    = string
  default = "linux-amd64"
}