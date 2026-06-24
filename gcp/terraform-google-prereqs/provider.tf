terraform {
  required_version = ">= 1.9"
}

provider "google" {
  project = var.gcp_project_id
  region  = var.region
}
