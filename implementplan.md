# CI/CD Implementation Plan for Three-Tier Java App

This plan outlines the steps to securely deploy your Java application to the GKE cluster using GitHub Actions.

## Proposed Changes

### [Infrastructure Extensions]

#### [NEW] [cicd.tf](file:///c:/Users/heman/learning/gcp/gke/cicd.tf)
New Terraform file to provision:
- **Workload Identity Federation (WIF)**: For keyless authentication from GitHub to GCP.
- **Artifact Registry**: To host the Docker images.

### [CI/CD Pipeline]

#### [NEW] [deploy.yml](file:///c:/Users/heman/learning/gcp/gke/.github/workflows/deploy.yml)
GitHub Actions workflow to:
- Build Docker images for Frontend and Backend.
- Push images to Artifact Registry.
- Deploy to GKE using `kubectl` or `helm`.

### [Application Manifests]

#### [NEW] [app/](file:///c:/Users/heman/learning/gcp/gke/app/)
Directory containing Kubernetes manifests for:
- **Frontend**: Deployment and Service (LoadBalancer).
- **Backend**: Deployment and Service (ClusterIP).
- **Database**: StatefulSet and Service (ClusterIP) - or externalized DB.

## Security Considerations
- **Workload Identity**: No service account keys stored in GitHub Secrets.
- **Network Policies**: Application pods will be labeled (`tier: frontend`, etc.) to match the existing policies.

## Verification Plan

### Automated Tests
- GitHub Action run verification.

### Manual Verification
- Verify application components are running and reachable according to the security policies.
