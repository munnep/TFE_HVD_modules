#------------------------------------------------------------------------------
# TFE URLs
#------------------------------------------------------------------------------
output "tfe_url" {
  value       = module.tfe.tfe_url
  description = "URL to access TFE application."
}

output "tfe_create_initial_admin_user_url" {
  value       = module.tfe.tfe_create_initial_admin_user_url
  description = "URL to create TFE initial admin user."
}

output "lb_dns_name" {
  value       = module.tfe.lb_dns_name
  description = "DNS name of the Load Balancer."
}

#------------------------------------------------------------------------------
# Bastion
#------------------------------------------------------------------------------
output "bastion_public_ip" {
  value       = module.tfe_prereqs.bastion_public_ip
  description = "Public IP address of bastion host."
}

output "bastion_public_dns" {
  value       = module.tfe_prereqs.bastion_public_dns
  description = "Public DNS name of bastion host."
}

#------------------------------------------------------------------------------
# Database
#------------------------------------------------------------------------------
output "tfe_database_host" {
  value       = module.tfe.tfe_database_host
  description = "PostgreSQL server endpoint in the format that TFE will connect to."
}

#------------------------------------------------------------------------------
# Object Storage
#------------------------------------------------------------------------------
output "s3_bucket_name" {
  value       = module.tfe.s3_bucket_name
  description = "Name of TFE S3 bucket."
}

output "tfe_execute_script_to_create_user_admin" {
  value = "./scripts/configure_tfe.sh ${var.tfe_fqdn} patrick.munne@ibm.com admin Password#1"
}
