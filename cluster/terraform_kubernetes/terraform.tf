terraform {
  required_version = "~> 1.3.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.46.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.1"
    }
    statuscake = {
      source  = "StatusCakeDev/statuscake"
      version = "2.0.4"
    }
  }
  backend "azurerm" {
    container_name = "tsc-tfstate"
  }
}

provider "azurerm" {
  subscription_id = try(local.azure_credentials.subscriptionId, null)
  client_id       = try(local.azure_credentials.clientId, null)
  client_secret   = try(local.azure_credentials.clientSecret, null)
  tenant_id       = try(local.azure_credentials.tenantId, null)
  features {}

  skip_provider_registration = true
}

data "azurerm_kubernetes_cluster" "main" {
  name                = local.cluster_name
  resource_group_name = var.resource_group_name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.main.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.main.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.main.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.main.kube_config[0].host
    client_key             = base64decode(data.azurerm_kubernetes_cluster.main.kube_config[0].client_key)
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.main.kube_config[0].client_certificate)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate)
  }
}

provider "statuscake" {
  api_token = local.api_token
}
