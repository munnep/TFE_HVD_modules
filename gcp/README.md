# Terraform Enterprise HVD Deployment on GCP

This directory contains Terraform configurations to deploy Terraform Enterprise on Google Cloud Platform using HashiCorp's Validated Design (HVD) modules.

## Overview

The GCP deployment uses a modular approach with three separate Terraform configurations that must be deployed in sequence:

1. **terraform-acme-tls-google**: Generates TLS certificates using ACME/Let's Encrypt
2. **terraform-google-prereqs**: Sets up GCP prerequisites (VPC, networking, secrets, Cloud SQL, Redis)
3. **terraform-google-terraform-enterprise-hvd**: Deploys Terraform Enterprise application

## Prerequisites

### Required Tools
- [Terraform](https://www.terraform.io/downloads) >= 1.9
- [gcloud CLI](https://cloud.google.com/sdk/docs/install) configured with appropriate credentials
- Valid Terraform Enterprise license

### GCP Requirements
- GCP Project with appropriate permissions
- Service account with necessary roles
- Service account key file (key.json)
- Cloud DNS managed zone (if using DNS automation)

## Initial GCP Setup

Before deploying Terraform Enterprise, you need to configure your GCP project and enable required APIs.

### 1. Configure gcloud CLI

```bash
# Set your service account
gcloud config set account <your-service-account>@<project-id>.iam.gserviceaccount.com

# Activate service account with key file
gcloud auth activate-service-account --key-file=key.json

# Set your project
gcloud config set project <your-project-id>

# Login for application default credentials
gcloud auth application-default login
```

### 2. Enable Required GCP APIs

Run the following commands to enable all necessary APIs:

```bash
# Enable Service Usage API (may require console activation first)
gcloud services enable serviceusage.googleapis.com

# Enable core compute and networking APIs
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable dns.googleapis.com

# Enable IAM and credentials APIs
gcloud services enable iamcredentials.googleapis.com
gcloud services enable iam.googleapis.com

# Enable cloud APIs
gcloud services enable cloudapis.googleapis.com
gcloud services enable servicemanagement.googleapis.com

# Enable storage APIs
gcloud services enable storage-api.googleapis.com
gcloud services enable storage.googleapis.com

# Enable database and cache APIs
gcloud services enable servicenetworking.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable redis.googleapis.com

# Enable container API (if using GKE)
gcloud services enable container.googleapis.com
```

> **Note**: If `serviceusage.googleapis.com` gives an error, you may need to enable it from the GCP Console first using the provided link.

## Deployment Instructions

The deployment must be done in three stages, with each directory deployed sequentially.

### Stage 1: Generate TLS Certificates

Navigate to the TLS certificate directory and deploy:

```bash
cd terraform-acme-tls-google

# Copy and configure variables
cp terraform.tfvars.example terraform.tfvars
vi terraform.tfvars

# Initialize Terraform
terraform init

# Plan and apply
terraform plan
terraform apply
```

**Required variables**:
- `project_id`: Your GCP project ID
- `region`: GCP region for deployment
- `dns_zone_name`: Cloud DNS managed zone name
- `tfe_fqdn`: Fully qualified domain name for TFE
- `email`: Email address for Let's Encrypt notifications

### Stage 2: Deploy Prerequisites

Navigate to the prerequisites directory and deploy:

```bash
cd ../terraform-google-prereqs

# Copy and configure variables
cp terraform.tfvars.example terraform.tfvars
vi terraform.tfvars

# Initialize Terraform
terraform init

# Plan and apply
terraform plan
terraform apply
```

**Required variables**:
- `project_id`: Your GCP project ID
- `region`: GCP region for deployment
- `friendly_name_prefix`: Unique prefix for resource naming
- `tfe_license_secret_value`: Your TFE license string
- `tfe_encryption_password_secret_value`: Encryption password
- `tfe_database_password_secret_value`: Database password
- Network CIDR ranges
- Database and Redis configurations

This stage creates:
- VPC and subnets
- Cloud SQL PostgreSQL instance
- Redis instance
- GCS bucket for TFE data
- Secret Manager secrets
- Service accounts and IAM roles

### Stage 3: Deploy Terraform Enterprise

Navigate to the TFE deployment directory and deploy:

```bash
cd ../terraform-google-terraform-enterprise-hvd

# Copy and configure variables
cp terraform.tfvars.example terraform.tfvars
vi terraform.tfvars

# Initialize Terraform
terraform init

# Plan and apply
terraform plan
terraform apply
```

**Required variables**:
- `project_id`: Your GCP project ID
- `region`: GCP region for deployment
- `friendly_name_prefix`: Same prefix used in prerequisites
- `tfe_fqdn`: Fully qualified domain name for TFE
- `tfe_image_tag`: TFE version to deploy
- Compute instance configurations
- Network settings

This stage creates:
- Managed Instance Group with TFE instances
- Load Balancer (internal or external)
- Health checks
- Firewall rules
- DNS records (if enabled)

## Accessing Terraform Enterprise

After successful deployment, retrieve the TFE URL:

```bash
cd terraform-google-terraform-enterprise-hvd
terraform output tfe_url
```

Navigate to the URL in your browser to access the TFE initial setup page.

## Architecture

The deployment creates:
- **VPC**: Isolated network with custom subnets
- **Load Balancer**: HTTP(S) Load Balancer for TFE traffic
- **Compute**: Managed Instance Group with auto-scaling
- **Database**: Cloud SQL PostgreSQL instance
- **Cache**: Cloud Memorystore Redis instance
- **Storage**: GCS bucket for TFE data
- **Secrets**: Secret Manager for sensitive data
- **TLS**: Automated certificate generation via ACME/Let's Encrypt
- **IAM**: Service accounts with least-privilege access

## State Management

Each module uses local state by default. The TFE deployment module reads the prerequisites state using `terraform_remote_state`:

```hcl
data "terraform_remote_state" "terraform-google-prereqs" {
  backend = "local"
  config = {
    path = "../terraform-google-prereqs/terraform.tfstate"
  }
}
```

## Cleanup

To destroy all resources, run terraform destroy in reverse order:

```bash
# Destroy TFE deployment
cd terraform-google-terraform-enterprise-hvd
terraform destroy

# Destroy prerequisites
cd ../terraform-google-prereqs
terraform destroy

# Destroy TLS certificates
cd ../terraform-acme-tls-google
terraform destroy
```

> **Warning**: This will permanently delete all resources including databases and data. Ensure you have backups if needed.

## Module Sources

This deployment uses the following HashiCorp modules:
- [terraform-acme-tls-google](https://github.com/hashicorp-services/terraform-acme-tls-google)
- [terraform-google-prereqs](https://github.com/hashicorp-services/terraform-google-prereqs)
- [terraform-google-terraform-enterprise-hvd](https://github.com/hashicorp/terraform-google-terraform-enterprise-hvd)
