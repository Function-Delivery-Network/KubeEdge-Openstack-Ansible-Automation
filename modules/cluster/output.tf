output "master_instance" {
  value = module.master.instances
}

output "worker_instances" {
  value = module.worker.instances
}

output "edge_instances" {
  value = module.edge.instances
}
