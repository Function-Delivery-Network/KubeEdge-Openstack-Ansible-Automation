variable "private_network_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "public_network_name" {
  type = string
}

variable "router_name" {
  type = string
}

variable "secgroup_name" {
  type = string
}

variable "secgroup_description" {
  type = string
}

variable "secgroup_rules" {
  type = list
}

variable "floatingip_pool" {
  type = string
}