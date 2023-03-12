#!/bin/bash
set -eu -o pipefail

source env.sh

# ############################################
# # STEP 1: create Azure Resource Group
# ############################################

echo "Creating resource group"

az group create \
  --resource-group $AZ_RESOURCE_GROUP \
  --location $AZ_LOCATION

############################################
# STEP 2: create network infrastructure
############################################

echo "Creating VNET"

az network vnet create \
  --resource-group $AZ_RESOURCE_GROUP \
  --name $AZ_VNET_NAME \
  --address-prefixes $AZ_VNET_RANGE \

echo "Creating subnet"

az network vnet subnet create \
  --resource-group $AZ_RESOURCE_GROUP \
  --vnet-name $AZ_VNET_NAME \
  --name $AZ_SUBNET_NAME \
  --address-prefixes $AZ_SUBNET_RANGE \
  
############################################
# STEP 3: create managed identity
############################################

echo "Createing identity"

az identity create \
  --name $AZ_AKS_IDENTITY_NAME \
  --resource-group $AZ_RESOURCE_GROUP

############################################
# STEP 4: fetch subnet and identity ids
############################################

echo "Fetching subnet and identity IDs"

export SUBNET_ID=$(az network vnet subnet show \
  --resource-group $AZ_RESOURCE_GROUP \
  --vnet-name $AZ_VNET_NAME \
  --name $AZ_SUBNET_NAME \
  --query id \
  --output tsv \
  | tr -d '\r'
) 

echo "Subnet ID: ${SUBNET_ID}"

export AZ_AKS_IDENTITY_ID=$(az identity show \
  --resource-group ${AZ_RESOURCE_GROUP} \
  --name ${AZ_AKS_IDENTITY_NAME} \
  --query id \
  --output tsv \
    | tr -d '\r'
)

echo "Identity ID: ${AZ_AKS_IDENTITY_ID}"


############################################
# STEP 5: create Azure Kubernetes Service cluster
############################################

echo "Creating AKS cluster"

az aks create \
    --resource-group $AZ_RESOURCE_GROUP \
    --name $AZ_AKS_CLUSTER_NAME \
    --kubernetes-version 1.23.5 \
    --generate-ssh-keys \
    --node-vm-size standard_b4ms \
    --enable-managed-identity \
    --assign-identity $AZ_AKS_IDENTITY_ID \
    --network-plugin "azure" \
    --network-policy "calico" \
    --vnet-subnet-id $SUBNET_ID \
    --node-count 3

############################################ 
# STEP 6: create KUBECONFIG to access AKS cluster
############################################

echo "Getting KUBECONFIG"

az aks get-credentials \
  --resource-group $AZ_RESOURCE_GROUP \
  --name $AZ_AKS_CLUSTER_NAME \
  --file $KUBECONFIG
