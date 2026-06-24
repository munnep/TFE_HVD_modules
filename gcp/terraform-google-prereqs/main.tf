data "terraform_remote_state" "terraform-acme-tls-google" {
  backend = "local"

  config = {
    path = "../terraform-acme-tls-google/terraform.tfstate"
  }
}


module "terraform-google-prereqs" {
  source = "git::https://github.com/hashicorp-services/terraform-google-prereqs.git"

  # --- Common --- #
  project_id           = var.gcp_project_id
  region               = var.region
  friendly_name_prefix = var.friendly_name_prefix
  common_labels        = var.common_labels

  # --- Networking --- #
  create_vpc                        = var.create_vpc
  cidr_allow_ingress_bastion        = var.cidr_allow_ingress_bastion
  cidr_allow_ingress_https          = var.cidr_allow_ingress_https
  create_vpc_private_service_access = var.create_vpc_private_service_access

  # --- KMS --- #
  create_gcs_kms       = var.create_gcs_kms
  gcs_keyring_location = "europe"
  create_sql_kms       = var.create_sql_kms

  # --- Secret Manager --- #
  tfe_license_secret              = var.tfe_license_secret
  tfe_encryption_password_secret  = var.tfe_encryption_password_secret
  tfe_database_password_secret    = var.tfe_database_password_secret
  tfe_tls_cert_secret_base64      = data.terraform_remote_state.terraform-acme-tls-google.outputs.tls_cert_base64
  tfe_tls_privkey_secret_base64   = data.terraform_remote_state.terraform-acme-tls-google.outputs.tls_privkey_base64
  tfe_tls_ca_bundle_secret_base64 = data.terraform_remote_state.terraform-acme-tls-google.outputs.tls_ca_bundle_base64
}
