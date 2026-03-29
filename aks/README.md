# AKS Cluster Terraform Configuration

## Prerequisites
- Terraform >= 1.0
- Azure CLI installed and logged in
- Sufficient permissions to create resource groups and AKS clusters

## Usage

1. **Configure variables**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your actual values

Initialize Terraform

bash
terraform init
Review the execution plan

bash
terraform plan
Deploy the cluster

bash
terraform apply
Get cluster access credentials

bash
az aks get-credentials --resource-group my-aks-rg --name my-production-aks
Verify the cluster

bash
kubectl get nodes


