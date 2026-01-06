resource "google_container_node_pool" "primary_nodes" {
  name       = var.node_pool_name
  location   = var.region
  cluster    = var.cluster_name
  node_count = var.node_count

  node_config {
    preemptible  = false
    machine_type = var.machine_type
    labels       = var.labels
    tags         = var.tags

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = var.service_account
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  # Ensure the node pool is spread across all zones in the region
  # This is default behavior for regional clusters when node_count is specified per zone.
  # If node_count = 1 and there are 3 zones, total nodes = 3.
}
