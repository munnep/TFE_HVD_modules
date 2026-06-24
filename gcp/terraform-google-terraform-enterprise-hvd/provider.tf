terraform {
  required_version = ">= 1.9"
}

provider "google" {
  project = var.project_id
  region  = var.region
}
