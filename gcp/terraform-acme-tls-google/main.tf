data "google_dns_managed_zone" "public" {
  name    = var.cloud_dns_managed_zone_name
  project = var.gcp_project_id
}


module "terraform-acme-tls-google" {
  source = "git::https://github.com/hashicorp-services/terraform-acme-tls-google.git"

  gcp_project_id              = var.gcp_project_id
  cloud_dns_managed_zone_name = var.cloud_dns_managed_zone_name
  tls_cert_fqdn               = var.tls_cert_fqdn
  tls_cert_email_address      = var.tls_cert_email_address
  create_cert_files           = var.create_cert_files
  add_cert_filename_prefix    = var.add_cert_filename_prefix 
}

output "tls_cert_base64" {
  value       = module.terraform-acme-tls-google.tls_cert_base64
  description = "Base64-encoded string of TLS certificate."
}

output "tls_fullchain_base64" {
  value       = module.terraform-acme-tls-google.tls_fullchain_base64
  description = "Base64-encoded string of TLS full-chain certificate."
}

output "tls_privkey_base64" {
  value       = module.terraform-acme-tls-google.tls_privkey_base64
  description = "Base64-encoded string of TLS private key."
  sensitive   = true
}

output "tls_ca_bundle_base64" {
  value       = module.terraform-acme-tls-google.tls_ca_bundle_base64
  description = "Base64-encoded string of TLS CA bundle."
}
