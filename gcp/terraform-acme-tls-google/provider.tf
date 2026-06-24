terraform {
  required_version = ">= 1.9"

  required_providers {
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.23"
    }
  }
}

provider "acme" {
  #server_url = "https://acme-staging-v02.api.letsencrypt.org/directory" # ACME staging - for testing the module
  server_url = "https://acme-v02.api.letsencrypt.org/directory" # ACME prod - for your real certs
}

provider "google" {
  region = var.region
}
