#------------------------------------------------------------------------------
# Networking
#------------------------------------------------------------------------------
output "vpc_name" {
  value       = module.terraform-google-prereqs.vpc_name
  description = "Name of VPC network."
}

output "subnet_name" {
  value       = module.terraform-google-prereqs.subnet_name
  description = "Name of subnetwork."
}

output "bastion_name" {
  value       = module.terraform-google-prereqs.bastion_name
  description = "Name of bastion VM."
}

output "bastion_zone" {
  value       = module.terraform-google-prereqs.bastion_zone
  description = "Zone of bastion VM."
}

output "bastion_public_ip" {
  value       = module.terraform-google-prereqs.bastion_public_ip
  description = "Public IP of bastion VM."
}

#------------------------------------------------------------------------------
# Key Management (KMS)
#------------------------------------------------------------------------------
output "kms_gcs_key_ring_name" {
  value       = module.terraform-google-prereqs.kms_gcs_key_ring_name
  description = "Name of keyring for GCS."
}

output "kms_gcs_crypto_key_name" {
  value       = module.terraform-google-prereqs.kms_gcs_crypto_key_name
  description = "Name of crypto key for GCS."
}

output "kms_sql_key_ring_name" {
  value       = module.terraform-google-prereqs.kms_sql_key_ring_name
  description = "Name of keyring for Cloud SQL."
}

output "kms_sql_crypto_key_name" {
  value       = module.terraform-google-prereqs.kms_sql_crypto_key_name
  description = "Name of crypto key for Cloud SQL."
}

output "kms_cloud_sql_keyring_name" {
  value       = module.terraform-google-prereqs.kms_cloud_sql_keyring_name
  description = "Name of KMS keyring for Cloud SQL."
}

output "kms_cloud_sql_cmek_name" {
  value       = module.terraform-google-prereqs.kms_cloud_sql_cmek_name
  description = "Name of KMS customer-managed encryption key (CMEK) for Cloud SQL."
}

#------------------------------------------------------------------------------
# TFE Secret Manager
#------------------------------------------------------------------------------
output "tfe_license_secret_id" {
  value       = module.terraform-google-prereqs.tfe_license_secret_id
  description = "Name of TFE license secret."
}

output "tfe_encryption_password_secret_id" {
  value       = module.terraform-google-prereqs.tfe_encryption_password_secret_id
  description = "Name of TFE encryption password secret."
}

output "tfe_database_password_secret_id" {
  value       = module.terraform-google-prereqs.tfe_database_password_secret_id
  description = "Name of TFE database password secret."
}

output "tfe_tls_cert_secret_id" {
  value       = module.terraform-google-prereqs.tfe_tls_cert_secret_id
  description = "Name of TFE TLS certificate secret."
}

output "tfe_tls_privkey_secret_id" {
  value       = module.terraform-google-prereqs.tfe_tls_privkey_secret_id
  description = "Name of TFE TLS private key secret."
}

output "tfe_tls_ca_bundle_secret_id" {
  value       = module.terraform-google-prereqs.tfe_tls_ca_bundle_secret_id
  description = "Name of the TFE TLS CA bundle secret."
}

#------------------------------------------------------------------------------
# Vault Secret Manager
#------------------------------------------------------------------------------
output "vault_license_secret_id" {
  value       = module.terraform-google-prereqs.vault_license_secret_id
  description = "Name of vault license secret."
}

output "vault_tls_cert_secret_id" {
  value       = module.terraform-google-prereqs.vault_tls_cert_secret_id
  description = "Name of vault TLS certificate secret."
}

output "vault_tls_privkey_secret_id" {
  value       = module.terraform-google-prereqs.vault_tls_privkey_secret_id
  description = "Name of vault TLS private key secret."
}

output "vault_tls_ca_bundle_secret_id" {
  value       = module.terraform-google-prereqs.vault_tls_ca_bundle_secret_id
  description = "Name of the vault TLS CA bundle secret."
}

#------------------------------------------------------------------------------
# Consul Secret Manager
#------------------------------------------------------------------------------
output "consul_license_secret_id" {
  value       = module.terraform-google-prereqs.consul_license_secret_id
  description = "Name of Consul license secret."
}

output "consul_tls_cert_secret_id" {
  value       = module.terraform-google-prereqs.consul_tls_cert_secret_id
  description = "Name of Consul TLS certificate secret."
}

output "consul_tls_privkey_secret_id" {
  value       = module.terraform-google-prereqs.consul_tls_privkey_secret_id
  description = "Name of Consul TLS private key secret."
}

output "consul_tls_ca_cert_secret_id" {
  value       = module.terraform-google-prereqs.consul_tls_ca_cert_secret_id
  description = "Name of the Consul TLS CA certificate secret."
}

output "consul_gossip_key_secret_id" {
  value       = module.terraform-google-prereqs.consul_gossip_key_secret_id
  description = "Name of Consul gossip encryption key secret."
}

#------------------------------------------------------------------------------
# Boundary Secret Manager
#------------------------------------------------------------------------------
output "boundary_license_secret_id" {
  value       = module.terraform-google-prereqs.boundary_license_secret_id
  description = "Name of Boundary license secret."
}

output "boundary_database_password_secret_id" {
  value       = module.terraform-google-prereqs.boundary_database_password_secret_id
  description = "Name of Boundary database password secret."
}

output "boundary_tls_cert_secret_id" {
  value       = module.terraform-google-prereqs.boundary_tls_cert_secret_id
  description = "Name of Boundary TLS certificate secret."
}

output "boundary_tls_privkey_secret_id" {
  value       = module.terraform-google-prereqs.boundary_tls_privkey_secret_id
  description = "Name of Boundary TLS private key secret."
}

output "boundary_tls_ca_bundle_secret_id" {
  value       = module.terraform-google-prereqs.boundary_tls_ca_bundle_secret_id
  description = "Name of the Boundary TLS CA bundle secret."
}

#------------------------------------------------------------------------------
# Nomad Secret Manager
#------------------------------------------------------------------------------
output "nomad_license_secret_id" {
  value       = module.terraform-google-prereqs.nomad_license_secret_id
  description = "Name of Nomad license secret."
}

output "nomad_tls_cert_secret_id" {
  value       = module.terraform-google-prereqs.nomad_tls_cert_secret_id
  description = "Name of Nomad TLS certificate secret."
}

output "nomad_tls_privkey_secret_id" {
  value       = module.terraform-google-prereqs.nomad_tls_privkey_secret_id
  description = "Name of Nomad TLS private key secret."
}

output "nomad_tls_ca_cert_secret_id" {
  value       = module.terraform-google-prereqs.nomad_tls_ca_cert_secret_id
  description = "Name of the Nomad TLS CA certificate secret."
}

output "nomad_gossip_key_secret_id" {
  value       = module.terraform-google-prereqs.nomad_gossip_key_secret_id
  description = "Name of Nomad gossip encryption key secret."
}
