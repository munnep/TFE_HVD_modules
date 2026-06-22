terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.74"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_key_pair" "deployer" {
  key_name   = var.friendly_name_prefix
  public_key = var.public_key
}


module "tfe_prereqs" {
  source = "git::https://github.com/hashicorp-services/terraform-aws-tfe-prereqs.git"

  # --- Common --- #
  friendly_name_prefix = var.friendly_name_prefix
  common_tags          = var.common_tags

  # --- Networking --- #
  create_vpc              = var.create_vpc
  vpc_cidr                = var.vpc_cidr
  lb_subnet_cidrs_public  = var.lb_subnet_cidrs_public
  lb_subnet_cidrs_private = var.lb_subnet_cidrs_private
  compute_subnet_cidrs    = var.compute_subnet_cidrs
  db_subnet_cidrs         = var.db_subnet_cidrs
  redis_subnet_cidrs      = var.redis_subnet_cidrs
  ngw_subnet_cidrs        = var.ngw_subnet_cidrs

  # --- Bastion --- #
  create_bastion                 = var.create_bastion
  bastion_instance_type          = var.bastion_instance_type
  bastion_ec2_keypair_name       = var.bastion_ec2_keypair_name
  bastion_cidr_allow_ingress_ssh = var.bastion_cidr_allow_ingress_ssh

  # --- TLS certificates --- #
  create_tls_certs                  = var.create_tls_certs
  tls_cert_fqdn                     = var.tls_cert_fqdn
  tls_cert_email_address            = var.tls_cert_email_address
  tls_cert_route53_public_zone_name = var.tls_cert_route53_public_zone_name
  create_local_cert_files           = var.create_local_cert_files

  # --- Secrets Manager --- #
  tfe_license_secret_value             = var.tfe_license_secret_value
  tfe_encryption_password_secret_value = var.tfe_encryption_password_secret_value
  tfe_database_password_secret_value   = var.tfe_database_password_secret_value
  tfe_redis_password_secret_value      = var.tfe_redis_password_secret_value
  tfe_secrets_manager_replica_regions  = var.tfe_secrets_manager_replica_regions

  # --- CloudWatch (optional) --- #
  create_cloudwatch_log_group = var.create_cloudwatch_log_group
  cloudwatch_log_group_name   = var.cloudwatch_log_group_name

  # --- KMS (optional) --- #
  create_kms_cmk = var.create_kms_cmk
  kms_cmk_alias  = var.kms_cmk_alias
}



module "tfe" {
  source = "git::https://github.com/hashicorp/terraform-aws-terraform-enterprise-hvd.git"

  # --- Common --- #
  friendly_name_prefix = var.friendly_name_prefix
  common_tags          = var.common_tags

  # --- Bootstrap --- #
  tfe_license_secret_arn             = module.tfe_prereqs.tfe_license_secret_arn
  tfe_encryption_password_secret_arn = module.tfe_prereqs.tfe_encryption_password_secret_arn
  tfe_tls_cert_secret_arn            = module.tfe_prereqs.tfe_tls_cert_secret_arn
  tfe_tls_privkey_secret_arn         = module.tfe_prereqs.tfe_tls_privkey_secret_arn
  tfe_tls_ca_bundle_secret_arn       = module.tfe_prereqs.tfe_tls_ca_bundle_secret_arn
  tfe_image_tag                      = var.tfe_image_tag

  # --- TFE configuration settings --- #
  tfe_fqdn               = var.tfe_fqdn
  tfe_operational_mode   = var.tfe_operational_mode
  tfe_metrics_enable     = var.tfe_metrics_enable
  tfe_metrics_http_port  = var.tfe_metrics_http_port
  tfe_metrics_https_port = var.tfe_metrics_https_port
  tfe_iact_subnets       = var.tfe_iact_subnets

  # --- Networking --- #
  vpc_id                               = module.tfe_prereqs.vpc_id
  lb_is_internal                       = var.lb_is_internal
  lb_subnet_ids                        = var.lb_is_internal ? module.tfe_prereqs.lb_subnet_ids_private : module.tfe_prereqs.lb_subnet_ids_public
  ec2_subnet_ids                       = module.tfe_prereqs.compute_subnet_ids
  rds_subnet_ids                       = module.tfe_prereqs.db_subnet_ids
  redis_subnet_ids                     = module.tfe_prereqs.redis_subnet_ids
  cidr_allow_ingress_tfe_443           = var.cidr_allow_ingress_tfe_443
  cidr_allow_ingress_ec2_ssh           = var.cidr_allow_ingress_ec2_ssh
  cidr_allow_ingress_tfe_metrics_http  = var.cidr_allow_ingress_tfe_metrics_http
  cidr_allow_ingress_tfe_metrics_https = var.cidr_allow_ingress_tfe_metrics_https

  # --- DNS (optional) --- #
  create_route53_tfe_dns_record      = var.create_route53_tfe_dns_record
  route53_tfe_hosted_zone_name       = var.route53_tfe_hosted_zone_name
  route53_tfe_hosted_zone_is_private = var.route53_tfe_hosted_zone_is_private

  # --- Compute --- #
  container_runtime  = var.container_runtime
  ec2_os_distro      = var.ec2_os_distro
  ec2_ssh_key_pair   = module.tfe_prereqs.tfe_ssh_keypair_name
  ec2_allow_ssm      = var.ec2_allow_ssm
  ec2_instance_size  = var.ec2_instance_size
  asg_instance_count = var.asg_instance_count

  # --- Database --- #
  tfe_database_password_secret_arn = module.tfe_prereqs.tfe_database_password_secret_arn
  tfe_database_name                = var.tfe_database_name
  tfe_database_user                = var.tfe_database_user
  tfe_database_parameters          = var.tfe_database_parameters
  rds_aurora_engine_version        = var.rds_aurora_engine_version
  rds_parameter_group_family       = var.rds_parameter_group_family
  rds_aurora_instance_class        = var.rds_aurora_instance_class
  rds_aurora_replica_count         = var.rds_aurora_replica_count
  rds_skip_final_snapshot          = var.rds_skip_final_snapshot

  # --- Redis --- #
  tfe_redis_password_secret_arn    = module.tfe_prereqs.tfe_redis_password_secret_arn
  redis_engine_version             = var.redis_engine_version
  redis_parameter_group_name       = var.redis_parameter_group_name
  redis_node_type                  = var.redis_node_type
  redis_multi_az_enabled           = var.redis_multi_az_enabled
  redis_automatic_failover_enabled = var.redis_automatic_failover_enabled

  # --- Log forwarding (optional) --- #
  tfe_log_forwarding_enabled = var.tfe_log_forwarding_enabled
  log_fwd_destination_type   = var.log_fwd_destination_type
  s3_log_fwd_bucket_name     = var.s3_log_fwd_bucket_name
  cloudwatch_log_group_name  = module.tfe_prereqs.cloudwatch_log_group_name
}

