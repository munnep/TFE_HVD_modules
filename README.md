# Terraform Enterprise HVD Deployment

This repository uses the official HashiCorp Validated Design (HVD) modules to deploy Terraform Enterprise on AWS.

## Overview

This deployment uses two main modules:
- **terraform-aws-tfe-prereqs**: Sets up prerequisites (VPC, networking, secrets, TLS certificates, bastion host)
- **terraform-aws-terraform-enterprise-hvd**: Deploys Terraform Enterprise in Active-Active mode

## Prerequisites

### Required Tools
- [Terraform](https://www.terraform.io/downloads) >= 1.9
- AWS CLI configured with appropriate credentials
- Valid Terraform Enterprise license

### AWS Requirements
- AWS Account with appropriate permissions
- AWS credentials configured (via `aws configure` or environment variables)
- Route53 hosted zone (if using DNS automation)
- Sufficient AWS service quotas for:
  - VPC and networking resources
  - EC2 instances
  - RDS Aurora PostgreSQL
  - ElastiCache Redis
  - S3 buckets
  - Secrets Manager

## Quick Start

### 1. Clone the Repository
```bash
git clone <repository-url>
cd TFE_HVD_modules/AWS/use_as_module
```

### 2. Configure Variables
Copy the example file and customize it with your specific values:

```bash
# Copy the example file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your settings
vi terraform.tfvars
```

**Important**: Update the following values in `terraform.tfvars`:
- `bastion_ec2_keypair_name`: Your SSH key pair name (must exist in AWS)
- `tfe_license_secret_value`: **Your actual TFE license string** (replace the placeholder)
- `region`: AWS region for deployment
- `friendly_name_prefix`: Unique prefix for resource naming
- `tfe_fqdn`: Fully qualified domain name for TFE
- `tfe_cert_email_address`: Your email for TLS certificate
- Network CIDR ranges (adjust as needed)
- Database and Redis configurations

> **Note**: The `terraform.tfvars` file is gitignored to prevent committing sensitive data. Always use `terraform.tfvars.example` as a template.

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Plan the Deployment
```bash
terraform plan
```

### 5. Deploy
```bash
terraform apply
```

### 6. Access TFE
After successful deployment, retrieve the TFE URL:
```bash
terraform output tfe_url
```

### 7. Create Initial Admin User
To create the first admin user, you can use the script to autogenerate it

```bash
./scripts/configure_tfe.sh <your-hostname> patrick.munne@ibm.com admin Password#1"
```


## Outputs

After deployment, the following outputs are available:

- `tfe_url`: Main TFE application URL
- `tfe_create_initial_admin_user_url`: URL to create initial admin user
- `lb_dns_name`: Load balancer DNS name
- `bastion_public_ip`: Bastion host IP (if enabled)
- `tfe_database_host`: PostgreSQL endpoint
- `s3_bucket_name`: TFE S3 bucket name
