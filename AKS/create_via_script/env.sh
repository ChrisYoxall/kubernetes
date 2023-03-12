#!/bin/bash

# Cluster name
export AZ_AKS_CLUSTER_NAME="aks-testing"

# resource group and location
export AZ_RESOURCE_GROUP="${AZ_AKS_CLUSTER_NAME}-rg"
export AZ_LOCATION="australiaeast"

# Cluster local kubeconfig configuration
export KUBECONFIG=~/.kube/${AZ_AKS_CLUSTER_NAME}

# network infrastructure
export AZ_VNET_NAME="${AZ_AKS_CLUSTER_NAME}-vnet"
export AZ_VNET_RANGE="10.0.0.0/8"
export AZ_SUBNET_NAME="${AZ_AKS_CLUSTER_NAME}-subnet"
export AZ_SUBNET_RANGE="10.200.0.0/16"

# managed identity name
export AZ_AKS_IDENTITY_NAME="${AZ_AKS_CLUSTER_NAME}-identity"