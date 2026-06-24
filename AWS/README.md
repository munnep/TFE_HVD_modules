# Terraform Enterprise HVD Deployment on AWS

This directory contains Terraform configurations to deploy Terraform Enterprise on AWS using HashiCorp's Validated Design (HVD) modules.

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

## Deployment Instructions

### 1. Clone the Repository
```bash
git clone <repository-url>
cd TFE_HVD_modules/AWS
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

### 5. Deploy (Three-Stage Targeted Deployment)

Due to dependencies between modules, the deployment must be done in three stages using targeted applies:

#### Stage 1: Create SSH Key Pair
First, create the SSH key pair resource that will be used by the bastion host:

```bash
terraform apply -target=aws_key_pair.deployer
```

Type `yes` when prompted to confirm.

#### Stage 2: Deploy Prerequisites Module
Next, deploy the tfe_prereqs module to create VPC, networking, secrets, and TLS certificates:

```bash
terraform apply -target=module.tfe_prereqs
```

Type `yes` when prompted to confirm.

#### Stage 3: Deploy TFE Module
Finally, deploy the TFE application module:

```bash
terraform apply -target=module.tfe
```

Type `yes` when prompted to confirm.

#### Stage 4: Final Apply (Optional)
Run a final apply to ensure all resources are in sync:

```bash
terraform apply
```

> **Why Three Stages?** The TFE module uses count conditions that depend on outputs from the tfe_prereqs module (like secret ARNs). Terraform cannot determine these values until the prereqs module is applied, causing "Invalid count argument" errors if deployed all at once.

### 6. Access TFE
After successful deployment, retrieve the TFE URL:
```bash
terraform output tfe_url
```

### 7. Create Initial Admin User
To create the first admin user, you can use the provided script:

```bash
./scripts/configure_tfe.sh <your-hostname> <your-email> <username> <password>
```

Example:
```bash
./scripts/configure_tfe.sh tfe.example.com patrick.munne@ibm.com admin "Password#1"
```

## Outputs

After deployment, the following outputs are available:

- `tfe_url`: Main TFE application URL
- `tfe_create_initial_admin_user_url`: URL to create initial admin user
- `lb_dns_name`: Load balancer DNS name
- `bastion_public_ip`: Bastion host IP (if enabled)
- `tfe_database_host`: PostgreSQL endpoint
- `s3_bucket_name`: TFE S3 bucket name

## Architecture

The deployment creates:
- **VPC**: Isolated network with public and private subnets across multiple AZs
- **Load Balancer**: Application Load Balancer for TFE traffic
- **Compute**: EC2 instances in an Auto Scaling Group
- **Database**: Aurora PostgreSQL cluster with read replicas
- **Cache**: ElastiCache Redis cluster
- **Storage**: S3 bucket for TFE data
- **Secrets**: AWS Secrets Manager for sensitive data
- **TLS**: Automated certificate generation via ACME/Let's Encrypt
- **Bastion**: Optional bastion host for secure SSH access

## Troubleshooting

### Common Issues

1. **Invalid count argument errors**: Ensure you follow the three-stage deployment process
2. **SSH key pair not found**: Create the key pair in AWS before deployment or update the variable
3. **Route53 zone not found**: Verify the hosted zone exists and the name is correct
4. **Insufficient permissions**: Ensure your AWS credentials have all required permissions

### Logs

- Check CloudWatch Logs (if enabled) for TFE application logs
- Use AWS Systems Manager Session Manager to access EC2 instances (if SSM is enabled)
- Connect via bastion host for direct SSH access

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

> **Warning**: This will permanently delete all resources including databases and data. Ensure you have backups if needed.

## Support

For issues or questions:
- Review the [main README](../README.md)
- Check the official [Terraform Enterprise documentation](https://developer.hashicorp.com/terraform/enterprise)
- Consult the [terraform-aws-terraform-enterprise-hvd module documentation](https://github.com/hashicorp/terraform-aws-terraform-enterprise-hvd)