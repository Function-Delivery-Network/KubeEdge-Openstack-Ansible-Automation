variable "cluster_name" {
  type = string
}

# Network variables

variable "floatingip_pool" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "pod_subnet" {
  type = string
}

variable "public_network_name" {
  type = string
}

variable "secgroup_description" {
  type    = string
  default = "k8s security group description"
}

variable "secgroup_rules" {
  type    = list(object({ cidr = string, ip_protocol = string, port = number }))
  default = [
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 22 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 6443 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 80 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 443 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 31001 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 31002 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 31003 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 31004 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 32007 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 32008 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 32009 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 32006 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 10000 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 10002 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 10003 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 10004 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 10350 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 10550 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 9100 },
    { "cidr" = "0.0.0.0/0", "ip_protocol" = "tcp", "port" = 9090 }
  ]
}

# Compute Variables

variable "master_count" {
  type = number
}

variable "worker_count" {
  type = number
}

variable "edge_count" {
  type = number
}

variable "instance_image_id" {
  type = string
}

variable "master_instance_flavor_name" {
  type = string
}

variable "worker_instance_flavor_name" {
  type = string
}

variable "edge_instance_flavor_name" {
  type = string
}

variable "instance_keypair_name" {
  type = string
}

variable "instance_availability_zone" {
  type    = string
  default = "nova"
}

variable "instance_block_device_source_type" {
  type    = string
  default = "image"
}

variable "instance_block_device_volume_size" {
  type = number
}

variable "instance_block_device_boot_index" {
  type    = number
  default = 0
}

variable "instance_block_device_destination_type" {
  type    = string
  default = "volume"
}

variable "instance_block_device_delete_on_termination" {
  type    = bool
  default = true
}

variable "instance_user" {
  type    = string
  default = "ubuntu"
}

variable "ssh_key_file" {
  type = string
}

variable "keadm_version" {
  type = string
}

variable "keadm_host_os" {
  type = string
}
