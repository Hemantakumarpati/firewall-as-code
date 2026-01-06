# Service Account for GKE Nodes
resource "google_service_account" "gke_sa" {
  account_id   = "${local.cluster_name}-sa"
  display_name = "Service Account for GKE Nodes"
}

# Jamming the modules together
module "vpc" {
  source          = "./modules/vpc"
  network_name    = local.network_name
  subnetwork_name = local.subnetwork_name
  region          = local.region
  subnet_cidr     = "10.0.0.0/16"
  pods_cidr       = "10.1.0.0/16"
  services_cidr   = "10.2.0.0/16"
  labels          = local.common_labels
}

module "gke_cluster" {
  source       = "./modules/gke_cluster"
  cluster_name = local.cluster_name
  region       = local.region
  network_id   = module.vpc.network_id
  subnet_id    = module.vpc.subnet_id
  labels       = local.common_labels
}

module "node_pool" {
  source          = "./modules/node_pool"
  node_pool_name  = "primary-node-pool"
  region          = local.region
  cluster_name    = module.gke_cluster.cluster_name
  node_count      = local.node_count
  machine_type    = local.machine_type
  service_account = google_service_account.gke_sa.email
  labels          = local.common_labels
  tags            = ["gke-frontend"]
}

# Firewall-as-Code: Native Kubernetes Network Policies
# This avoids the "REST client" error during the initial 'terraform plan/apply'

resource "kubernetes_network_policy" "frontend" {
  metadata {
    name      = "frontend-policy"
    namespace = "default"
  }
  spec {
    pod_selector {
      match_labels = { tier = "frontend" }
    }
    policy_types = ["Ingress", "Egress"]
    ingress {
      from {
        ip_block { cidr = "130.211.0.0/22" }
      }
      from {
        ip_block { cidr = "35.191.0.0/16" }
      }
      ports {
        protocol = "TCP"
        port     = 8080
      }
    }
    egress {
      to {
        pod_selector {
          match_labels = { tier = "backend" }
        }
      }
      ports {
        protocol = "TCP"
        port     = 8080
      }
    }
  }
  depends_on = [module.node_pool]
}

resource "kubernetes_network_policy" "backend" {
  metadata {
    name      = "backend-policy"
    namespace = "default"
  }
  spec {
    pod_selector {
      match_labels = { tier = "backend" }
    }
    policy_types = ["Ingress", "Egress"]
    ingress {
      from {
        pod_selector {
          match_labels = { tier = "frontend" }
        }
      }
      ports {
        protocol = "TCP"
        port     = 8080
      }
    }
    egress {
      to {
        pod_selector {
          match_labels = { tier = "database" }
        }
      }
      ports {
        protocol = "TCP"
        port     = 5432
      }
    }
  }
  depends_on = [module.node_pool]
}

resource "kubernetes_network_policy" "database" {
  metadata {
    name      = "database-policy"
    namespace = "default"
  }
  spec {
    pod_selector {
      match_labels = { tier = "database" }
    }
    policy_types = ["Ingress"]
    ingress {
      from {
        pod_selector {
          match_labels = { tier = "backend" }
        }
      }
      ports {
        protocol = "TCP"
        port     = 5432
      }
    }
  }
  depends_on = [module.node_pool]
}
