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
# Cloud Cluster
resource "local_file" "group_vars" {
  content = templatefile("./templates/group_vars.tpl",
    {
      pod_subnet    = var.pod_subnet
      cluster_name  = var.cluster_name
      keadm_version = var.keadm_version
      keadm_host_os = var.keadm_host_os
    }
  )
  filename = "./ansible/group_vars/${var.cluster_name}"
}

resource "local_file" "hosts" {
  content = templatefile("./templates/hosts.tpl",
    {
      cluster_name     = var.cluster_name
      master_instances = module.master.instances
      worker_instances = module.worker.instances
      edge_instances   = module.edge.instances
    }
  )
  filename = "./ansible/${var.cluster_name}_hosts.ini"
}

# Local variables to reduce duplicates
locals {
  secgroup_name = "${var.cluster_name}_sg"
  network_name  = "${var.cluster_name}_network"
}

# Create the network
module "networking" {
  source               = "../networking"
  private_network_name = local.network_name
  subnet_name          = "${var.cluster_name}_subnet"
  subnet_cidr          = var.subnet_cidr
  public_network_name  = var.public_network_name
  router_name          = "${var.cluster_name}_router"
  secgroup_name        = local.secgroup_name
  secgroup_description = var.secgroup_description
  secgroup_rules       = var.secgroup_rules
  floatingip_pool      = var.floatingip_pool
}

module "master" {
  source                                      = "../compute"
  instance_depends_on                         = [module.networking.subnet, local_file.group_vars]
  cluster_name                                = var.cluster_name
  instance_role                               = "master"
  instance_count                              = var.master_count
  instance_image_id                           = var.instance_image_id
  instance_flavor_name                        = var.master_instance_flavor_name
  instance_keypair_name                       = var.instance_keypair_name
  instance_availability_zone                  = var.instance_availability_zone
  instance_block_device_source_type           = var.instance_block_device_source_type
  instance_block_device_volume_size           = var.instance_block_device_volume_size
  instance_block_device_boot_index            = var.instance_block_device_boot_index
  instance_block_device_destination_type      = var.instance_block_device_destination_type
  instance_block_device_delete_on_termination = var.instance_block_device_delete_on_termination
  secgroup_name                               = local.secgroup_name
  network_name                                = local.network_name
  instance_user                               = var.instance_user
  ssh_key_file                                = var.ssh_key_file
  floatingip_pool                             = var.floatingip_pool
  network_subnet_id                           = module.networking.subnet.id
}

module "worker" {
  source                                      = "../compute"
  instance_depends_on                         = [module.networking.subnet, local_file.group_vars]
  cluster_name                                = var.cluster_name
  instance_role                               = "worker"
  instance_count                              = var.worker_count
  instance_image_id                           = var.instance_image_id
  instance_flavor_name                        = var.worker_instance_flavor_name
  instance_keypair_name                       = var.instance_keypair_name
  instance_availability_zone                  = var.instance_availability_zone
  instance_block_device_source_type           = var.instance_block_device_source_type
  instance_block_device_volume_size           = var.instance_block_device_volume_size
  instance_block_device_boot_index            = var.instance_block_device_boot_index
  instance_block_device_destination_type      = var.instance_block_device_destination_type
  instance_block_device_delete_on_termination = var.instance_block_device_delete_on_termination
  secgroup_name                               = local.secgroup_name
  network_name                                = local.network_name
  instance_user                               = var.instance_user
  ssh_key_file                                = var.ssh_key_file
  floatingip_pool                             = var.floatingip_pool
  network_subnet_id                           = module.networking.subnet.id
  #network_pool_id                             = module.networking.pool.id
}

module "edge" {
  source                                      = "../compute"
  instance_depends_on                         = [module.networking.subnet, local_file.group_vars]
  cluster_name                                = var.cluster_name
  instance_role                               = "edge"
  instance_count                              = var.edge_count
  instance_image_id                           = var.instance_image_id
  instance_flavor_name                        = var.edge_instance_flavor_name
  instance_keypair_name                       = var.instance_keypair_name
  instance_availability_zone                  = var.instance_availability_zone
  instance_block_device_source_type           = var.instance_block_device_source_type
  instance_block_device_volume_size           = var.instance_block_device_volume_size
  instance_block_device_boot_index            = var.instance_block_device_boot_index
  instance_block_device_destination_type      = var.instance_block_device_destination_type
  instance_block_device_delete_on_termination = var.instance_block_device_delete_on_termination
  secgroup_name                               = local.secgroup_name
  network_name                                = local.network_name
  instance_user                               = var.instance_user
  ssh_key_file                                = var.ssh_key_file
  floatingip_pool                             = var.floatingip_pool
  #network_pool_id                             = module.networking.pool.id
  network_subnet_id                           = module.networking.subnet.id
}

# Run Ansible

resource "null_resource" "ansible_master" {
  count    = var.master_count
  triggers = {
    master_instance_id = module.master.instances[count.index].id
  }

  provisioner "remote-exec" {
    inline = ["#Connected"]

    connection {
      user        = var.instance_user
      host        = module.master.instances[count.index].floating_ip
      private_key = file(var.ssh_key_file)
      agent       = "true"
    }
  }

  provisioner "local-exec" {
    command = <<EOT
    cd ansible;
    ansible-playbook -i ${var.cluster_name}_hosts.ini master.yml
    EOT
  }
}

resource "null_resource" "ansible_worker" {
  count    = var.worker_count
  triggers = {
    worker_instance_id = module.worker.instances[count.index].id
  }

  provisioner "remote-exec" {
    inline = ["#Connected"]

    connection {
      user        = var.instance_user
      host        = module.worker.instances[count.index].floating_ip
      private_key = file(var.ssh_key_file)
      agent       = "true"
    }
  }

  provisioner "local-exec" {
    command = <<EOT
    cd ansible;
    ansible-playbook -i ${var.cluster_name}_hosts.ini worker.yml
    EOT
  }
  depends_on = [null_resource.ansible_master]
}

resource "null_resource" "ansible_master_after" {
  count    = 1
  triggers = {
    master_instance_id = module.master.instances[count.index].id
  }

  provisioner "remote-exec" {
    inline = ["#Connected"]

    connection {
      user        = var.instance_user
      host        = module.master.instances[count.index].floating_ip
      private_key = file(var.ssh_key_file)
      agent       = "true"
    }
  }

  provisioner "local-exec" {
    command = <<EOT
    cd ansible;
    ansible-playbook -i ${var.cluster_name}_hosts.ini master-after-join.yml
    EOT
  }
  depends_on = [null_resource.ansible_master]
}

resource "null_resource" "ansible_master_kube_edge_cloud" {
  count    = 1
  triggers = {
    master_instance_id = module.master.instances[count.index].id
  }

  provisioner "remote-exec" {
    inline = ["#Connected"]

    connection {
      user        = var.instance_user
      host        = module.master.instances[count.index].floating_ip
      private_key = file(var.ssh_key_file)
      agent       = "true"
    }
  }

  provisioner "local-exec" {
    command = <<EOT
    cd ansible;
    ansible-playbook -i ${var.cluster_name}_hosts.ini kube_edge_cloud.yml
    EOT
  }
  depends_on = [null_resource.ansible_master_after]
}

resource "null_resource" "ansible_edge" {
  count    = var.edge_count
  triggers = {
    worker_instance_id = module.edge.instances[count.index].id
  }

  provisioner "remote-exec" {
    inline = ["#Connected"]

    connection {
      user        = var.instance_user
      host        = module.edge.instances[count.index].floating_ip
      private_key = file(var.ssh_key_file)
      agent       = "true"
    }
  }

  provisioner "local-exec" {
    command = <<EOT
    cd ansible;
    ansible-playbook -i ${var.cluster_name}_hosts.ini kube_edge_edge.yml
    EOT
  }
  depends_on = [null_resource.ansible_master_kube_edge_cloud]
}

# resource "null_resource" "ansible_master_sedna" {
#   count = 1
#   triggers = {
#     master_instance_id = module.master.instances[count.index].id
#   }

#   provisioner "remote-exec" {
#     inline = ["#Connected"]

#     connection {
#       user        = var.instance_user
#       host        = module.master.instances[count.index].floating_ip
#       private_key = file(var.ssh_key_file)
#       agent       = "true"
#     }
#   }

#   provisioner "local-exec" {
#     command = <<EOT
#     cd ansible;
#     ansible-playbook -i ${var.cluster_name}_hosts.ini sedna.yml
#     EOT
#   }
#   depends_on = [null_resource.ansible_edge]
# }

# Cleanup resources
resource "null_resource" "cleanup" {
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
     rm -rf ./ansible/from_remote/*
     EOT
  }
}
