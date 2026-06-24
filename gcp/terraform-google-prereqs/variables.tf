#------------------------------------------------------------------------------
# Common
#------------------------------------------------------------------------------

variable "gcp_project_id" {
  type        = string
  description = "ID of GCP project to create resources in."
}

variable "region" {
  type        = string
  description = "GCP region to create resource in."
}

variable "friendly_name_prefix" {
  type        = string
  description = "Friendly name prefix for uniquely naming GCP resource."
}

variable "common_labels" {
  type        = map(string)
  description = "Common labels to apply to GCP resources."
  default     = {}

  validation {
    condition     = alltrue([for key, value in var.common_labels : can(regex("^[a-z][a-z0-9_-]{0,62}$", key)) && can(regex("^[a-z][a-z0-9_-]{0,62}$", value))])
    error_message = "All keys and values must start with a lowercase letter and only contain lowercase letters, digits, underscores, or hyphens, and be no longer than 63 characters."
  }
}

#------------------------------------------------------------------------------
# Networking
#------------------------------------------------------------------------------

variable "create_vpc" {
  type        = bool
  description = "Boolean to create VPC network."
  default     = false
}

variable "vpc_name" {
  type        = string
  description = "Name of VPC network to create."
  default     = "terraform-vpc"
}

variable "subnet_name" {
  type        = string
  description = "Name of VPC subnetwork to create."
  default     = "terraform-subnet"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR range of VPC subnetwork to create."
  default     = "10.0.0.0/24"
}

variable "create_router_nat" {
  type        = bool
  description = "Boolean to create NAT configuration in router."
  default     = true
}

variable "create_vpc_private_service_access" {
  type        = bool
  description = "Boolean to enable private service access for VPC."
  default     = true
}

variable "cidr_allow_ingress_bastion" {
  type        = list(string)
  description = "List of source CIDR ranges to allow inbound to VPC on port 22 (SSH) to access the bastion host."
  default     = []
}

variable "cidr_allow_ingress_https" {
  type        = list(string)
  description = "List of source CIDR ranges of users/clients/VCS to allow inbound to VPC on port 443 (HTTPS) for TFE application traffic."
  default     = []
}

variable "cidr_allow_ingress_lb_health_probes" {
  type        = list(string)
  description = "List of GCP source CIDR ranges to allow inbound to VPC on port 443 (HTTPS) for load balancer health probe traffic."
  # https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges
  default = ["35.191.0.0/16", "130.211.0.0/22"]
}


#------------------------------------------------------------------------------
# Secret Manager
#------------------------------------------------------------------------------

variable "tfe_license_secret" {
  type        = string
  description = "Value of the raw contents of your TFE license file secret to create in Google Secret Manager."
  default     = null
}

variable "tfe_encryption_password_secret" {
  type        = string
  description = "Value of TFE encryption password secret to create in Google Secret Manager."
  default     = null
}

variable "tfe_database_password_secret" {
  type        = string
  description = "Value of TFE PostgreSQL database password secret to create in Google Secret Manager."
  default     = null
}

variable "tfe_tls_cert_secret_base64" {
  type        = string
  description = "Base64-encoded value of TFE TLS certificate secret to create in Google Secret Manager. Certificate must be in PEM format before base64-encoding."
  default     = null
}

variable "tfe_tls_privkey_secret_base64" {
  type        = string
  description = "Base64-encoded value of TFE TLS private key secret to create in Google Secret Manager. Private key must be in PEM format before base64-encoding."
  default     = null
}

variable "tfe_tls_ca_bundle_secret_base64" {
  type        = string
  description = "Base64-encoded value of TFE custom CA bundle secret to create in Secret Manager. CA bundle must be stored in PEM format before base64-encoding."
  default     = null
}

#------------------------------------------------------------------------------
# Key Management (KMS)
#------------------------------------------------------------------------------

variable "create_gcs_kms" {
  type        = bool
  description = "Boolean to create KMS resources for GCS bucket."
  default     = false
}

variable "gcs_keyring_location" {
  type = string

  description = "[Optional one of `ca`,`us`, `europe`, `asia`,`au`,`nam-eur-asia1`] Location of KMS resources for GCS bucket.  All regions are multi-region https://cloud.google.com/kms/docs/locations"
  default     = "us"
  validation {
    condition     = can(anytrue([contains(["ca", "us", "europe", "asia", "au", "nam-eur-asia1"], var.gcs_keyring_location), var.gcs_keyring_location == null]))
    error_message = "Supported values are `ca`,`us`, `europe`, `asia`,`au`,`nam-eur-asia1`; all regions are multi-region https://cloud.google.com/kms/docs/locations"
  }
}

variable "create_sql_kms" {
  type        = bool
  description = "Boolean to create KMS resources for Cloud SQL."
  default     = false
}

#------------------------------------------------------------------------------
# Cloud DNS
#------------------------------------------------------------------------------

variable "create_cloud_dns_zone" {
  type        = bool
  description = "Boolean to create Cloud DNS Zone."
  default     = false
}

variable "cloud_dns_zone_name" {
  type        = string
  description = "Name to the Cloud DNS zone. Required when `create_cloud_dns_zone` is `true`."
  default     = null
}

variable "cloud_dns_zone_domain" {
  type        = string
  description = "DNS name suffix of the Cloud DNS zone. Required when `create_cloud_dns_zone` is `true`."
  default     = null
}
