output "cluster_name" {
  value = module.gke_cluster.cluster_name
}

output "cluster_endpoint" {
  value = module.gke_cluster.cluster_endpoint
}

output "network_name" {
  value = local.network_name
}

output "subnet_name" {
  value = module.vpc.subnet_name
}
