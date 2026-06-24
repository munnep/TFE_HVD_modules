# Copyright IBM Corp. 2024, 2026
# SPDX-License-Identifier: MPL-2.0

#------------------------------------------------------------------------------
# TFE URLs
#------------------------------------------------------------------------------
output "tfe_url" {
  value = module.terraform-google-terraform-enterprise-hvd.tfe_url
}

output "tfe_retrieve_iact_url" {
  value = module.terraform-google-terraform-enterprise-hvd.tfe_retrieve_iact_url
}

output "tfe_create_initial_admin_user_url" {
  value = module.terraform-google-terraform-enterprise-hvd.tfe_create_initial_admin_user_url
}
