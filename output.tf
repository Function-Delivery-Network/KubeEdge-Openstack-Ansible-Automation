output "cloud_cluster_master_instance" {
  value = module.cloud_cluster.master_instance
}

output "cloud_cluster_worker_instances" {
  value = module.cloud_cluster.worker_instances
}

# output "cloud_cluster_loadbalancer_service_ip" {
#   value = module.cloud_cluster.loadbalancer_service_ip
# }

# output "edge_cluster_master_instance" {
#   value = module.edge_cluster.master_instance
# }

# output "edge_cluster_worker_instances" {
#   value = module.edge_cluster.worker_instances
# }

# output "edge_cluster_loadbalancer_service_ip" {
#   value = module.edge_cluster.loadbalancer_service_ip
# }