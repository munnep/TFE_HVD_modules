# Terraform Enterprise HVD Deployment

This repository uses the official HashiCorp Validated Design (HVD) modules to deploy Terraform Enterprise across multiple cloud providers.

## Overview

This repository contains Terraform configurations for deploying Terraform Enterprise (TFE) on:
- **AWS** - Active-Active mode deployment with full prerequisites automation
- **GCP** - Google Cloud Platform deployment with modular approach
- **Azure** - Azure deployment with comprehensive prerequisites (in development)

Each cloud provider directory contains the necessary modules and configurations to deploy TFE using HashiCorp's validated designs.

## Repository Structure

```
.
├── AWS/                    # AWS deployment configurations
├── gcp/                    # GCP deployment configurations
│   ├── terraform-acme-tls-google/           # TLS certificate generation
│   ├── terraform-google-prereqs/            # GCP prerequisites
│   └── terraform-google-terraform-enterprise-hvd/  # TFE deployment
└── Azure/                  # Azure deployment configurations
    └── terraform-azurerm-prereqs/           # Azure prerequisites
```

## Cloud Provider Deployments

### AWS
The AWS deployment uses two main modules:
- **terraform-aws-tfe-prereqs**: Sets up prerequisites (VPC, networking, secrets, TLS certificates, bastion host)
- **terraform-aws-terraform-enterprise-hvd**: Deploys Terraform Enterprise in Active-Active mode

**See [AWS/README.md](AWS/README.md) for detailed AWS deployment instructions.**

### GCP
The GCP deployment uses a modular approach with three separate Terraform configurations:
- **terraform-acme-tls-google**: Generates TLS certificates using ACME/Let's Encrypt
- **terraform-google-prereqs**: Sets up GCP prerequisites (VPC, networking, secrets, Cloud SQL, Redis)
- **terraform-google-terraform-enterprise-hvd**: Deploys Terraform Enterprise

**See [gcp/README.md](gcp/README.md) for detailed GCP deployment instructions.**

### Azure
The Azure deployment includes comprehensive prerequisites for TFE and other HashiCorp products.
- **terraform-azurerm-prereqs**: Sets up Azure prerequisites (VNet, networking, Key Vault, storage, etc.)

**See [Azure/terraform-azurerm-prereqs/README.md](Azure/terraform-azurerm-prereqs/README.md) for detailed Azure deployment instructions.**

## Prerequisites

### Required Tools
- [Terraform](https://www.terraform.io/downloads) >= 1.9
- Cloud provider CLI tools:
  - AWS CLI (for AWS deployments)
  - gcloud CLI (for GCP deployments)
  - Azure CLI (for Azure deployments)
- Valid Terraform Enterprise license

### Cloud Provider Requirements

#### AWS
- AWS Account with appropriate permissions
- AWS credentials configured (via `aws configure` or environment variables)
- Route53 hosted zone (if using DNS automation)
- Sufficient AWS service quotas

#### GCP
- GCP Project with appropriate permissions
- Service account with necessary roles
- GCP APIs enabled (compute, networking, SQL, Redis, etc.)
- Cloud DNS managed zone (if using DNS automation)

#### Azure
- Azure subscription with appropriate permissions
- Azure credentials configured
- Azure DNS zone (if using DNS automation)

## Quick Start

Choose your cloud provider and follow the specific README:

1. **AWS**: Navigate to `AWS/` directory and follow [AWS/README.md](AWS/README.md)
2. **GCP**: Navigate to `gcp/` directory and follow [gcp/README.md](gcp/README.md)
3. **Azure**: Navigate to `Azure/terraform-azurerm-prereqs/` directory and follow the README

## Common Features

All deployments support:
- ✅ High Availability (Active-Active mode)
- ✅ Automated TLS certificate generation
- ✅ Managed PostgreSQL database
- ✅ Redis cache for session management
- ✅ Object storage for application data
- ✅ Secrets management (AWS Secrets Manager, GCP Secret Manager, Azure Key Vault)
- ✅ Network isolation and security groups
- ✅ Optional bastion host for secure access
- ✅ DNS automation (optional)
- ✅ Log forwarding capabilities

## Support

For issues or questions:
- Review the cloud-specific README files
- Check the official HashiCorp Validated Design documentation
- Consult the Terraform Enterprise documentation

## License

This repository uses HashiCorp's official HVD modules. Ensure you have a valid Terraform Enterprise license before deployment.
