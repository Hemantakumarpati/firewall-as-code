# Artifact Registry Repository for Docker images
resource "google_artifact_registry_repository" "repo" {
  location      = local.region
  repository_id = local.artifact_repo_name
  description   = "Docker repository for three-tier Java application"
  format        = "DOCKER"
  force_destroy = true
}

# Workload Identity Federation for GitHub Actions
module "gh_oidc" {
  source      = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version     = "~> 3.1"
  project_id  = local.project_id
  pool_id     = "github-pool"
  provider_id = "github-provider"
  sa_mappings = {
    "github-deploy-sa" = {
      sa_name   = google_service_account.github_deploy.name
      attribute = "attribute.repository/${local.github_repo}"
    }
  }
}

# Service Account for GitHub Actions deployment
resource "google_service_account" "github_deploy" {
  account_id   = "github-deploy-sa"
  display_name = "Service Account for GitHub Actions Deployment"
}

# IAM Permissions for GitHub Actions Service Account
resource "google_project_iam_member" "ar_writer" {
  project = local.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_deploy.email}"
}

resource "google_project_iam_member" "gke_developer" {
  project = local.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.github_deploy.email}"
}

# Output WIF details for GitHub secret configuration
output "wif_provider_name" {
  value = module.gh_oidc.provider_name
}

output "github_service_account" {
  value = google_service_account.github_deploy.email
}
