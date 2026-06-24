data "terraform_remote_state" "terraform-google-prereqs" {
  backend = "local"

  config = {
    path = "../terraform-google-prereqs/terraform.tfstate"
  }
}


module "terraform-google-terraform-enterprise-hvd" {
  source = "git::https://github.com/hashicorp/terraform-google-terraform-enterprise-hvd.git"

  # --- Common --- #
  project_id           = var.project_id
  region               = var.region
  friendly_name_prefix = var.friendly_name_prefix
  common_labels        = var.common_labels

  # --- Bootstrap --- #
  tfe_license_secret_id             = data.terraform_remote_state.terraform-google-prereqs.outputs.tfe_license_secret_id[0]
  tfe_encryption_password_secret_id = data.terraform_remote_state.terraform-google-prereqs.outputs.tfe_encryption_password_secret_id[0]
  tfe_tls_cert_secret_id            = data.terraform_remote_state.terraform-google-prereqs.outputs.tfe_tls_cert_secret_id
  tfe_tls_privkey_secret_id         = data.terraform_remote_state.terraform-google-prereqs.outputs.tfe_tls_privkey_secret_id
  tfe_tls_ca_bundle_secret_id       = data.terraform_remote_state.terraform-google-prereqs.outputs.tfe_tls_ca_bundle_secret_id

  # --- TFE config settings --- #
  tfe_fqdn                   = var.tfe_fqdn
  tfe_image_tag              = var.tfe_image_tag
  tfe_admin_https_port       = var.tfe_admin_https_port
  tfe_admin_console_disabled = var.tfe_admin_console_disabled

  # --- Networking --- #
  vpc_network_name                     = data.terraform_remote_state.terraform-google-prereqs.outputs.vpc_name
  lb_is_internal                       = var.lb_is_internal
  lb_subnet_name                       = var.lb_subnet_name
  vm_subnet_name                       = data.terraform_remote_state.terraform-google-prereqs.outputs.subnet_name
  cidr_allow_ingress_tfe_443           = var.cidr_allow_ingress_tfe_443
  cidr_allow_ingress_tfe_admin_console = var.cidr_allow_ingress_tfe_admin_console
  allow_ingress_vm_ssh_from_iap        = var.allow_ingress_vm_ssh_from_iap
  tfe_iact_subnets                     = var.tfe_iact_subnets

  # --- DNS (optional) --- #
  create_tfe_cloud_dns_record = var.create_tfe_cloud_dns_record
  cloud_dns_managed_zone_name = var.cloud_dns_managed_zone_name

  # --- Compute --- #
  mig_instance_count    = var.mig_instance_count
  gce_image_name        = var.gce_image_name
  gce_image_project     = var.gce_image_project
  container_runtime     = var.container_runtime
  postgres_machine_type = var.postgres_machine_type

  # --- Database --- #
  tfe_database_password_secret_id = data.terraform_remote_state.terraform-google-prereqs.outputs.tfe_database_password_secret_id

  # --- KMS customer managed encryption keys (CMEK) --- #
  # Note: KMS outputs are not available from prereqs module, commenting out
  # postgres_kms_keyring_name = data.terraform_remote_state.terraform-google-prereqs.outputs.kms_sql_key_ring_name
  # postgres_kms_cmek_name    = data.terraform_remote_state.terraform-google-prereqs.outputs.kms_sql_crypto_key_name
  # gcs_kms_keyring_name      = data.terraform_remote_state.terraform-google-prereqs.outputs.kms_gcs_key_ring_name
  # gcs_kms_cmek_name         = data.terraform_remote_state.terraform-google-prereqs.outputs.kms_gcs_crypto_key_name

  # --- Log forwarding (optional) --- #
  tfe_log_forwarding_enabled = var.tfe_log_forwarding_enabled
  log_fwd_destination_type   = var.log_fwd_destination_type
}
