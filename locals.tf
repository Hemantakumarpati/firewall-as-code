locals {
  project_id      = "your-project-id" # USER needs to fill this
  region          = "us-central1"
  zones           = ["us-central1-a", "us-central1-b", "us-central1-c"]
  cluster_name    = "ha-gke-cluster"
  network_name    = "gke-vpc"
  subnetwork_name = "gke-subnet"
  node_count      = 1 # 1 node per zone = 3 total
  machine_type    = "e2-medium"

  common_labels = {
    env        = "production"
    managed_by = "terraform"
    team       = "devops"
    project    = "gke-ha-setup"
  }

  github_repo = "YOUR_ORG/YOUR_REPO" # Update with your GitHub repo (e.g., "myorg/myapp")
  
  # Artifact Registry repo names
  artifact_repo_name     = "java-app-repo"
  frontend_image_name    = "frontend"
  backend_image_name     = "backend"
}
