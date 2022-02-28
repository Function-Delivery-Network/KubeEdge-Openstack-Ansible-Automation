variable "instance_depends_on" {
  type    = any
  default = null
}

variable "instance_image_id" {
  type = string
}

variable "instance_flavor_name" {
  type = string
}

variable "instance_keypair_name" {
  type        = string
  description = "SSH keypair name"
}

variable "instance_availability_zone" {
  type = string
}

variable "instance_block_device_source_type" {
  type = string
}

variable "instance_block_device_volume_size" {
  type = number
}

variable "instance_block_device_boot_index" {
  type = number
}

variable "instance_block_device_destination_type" {
  type = string
}

variable "instance_block_device_delete_on_termination" {
  type = bool
}

variable "secgroup_name" {
  type = string
}

variable "network_name" {
  type = string
}

variable "instance_user" {
  type = string
}

variable "ssh_key_file" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "instance_role" {
  type = string
}

variable "floatingip_pool" {
  type = string
}

variable "instance_count" {
  type = number
}

# variable "network_pool_id" {
#   type = string
# }

variable "network_subnet_id" {
  type = string
}