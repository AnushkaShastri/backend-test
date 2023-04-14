provider "azurerm" {
  features {}
}
terraform {
 backend "http" {
    update_method = "POST"
    lock_method = "POST"
    unlock_method = "POST"
 }
}
locals {
  tags = {
      createdBy        = var.createdBy
      project          = var.project
      projectComponent = var.projectComponent
    }
}
resource "azurerm_resource_group" "rg" {
  name     = "${var.env}-${var.resource_group_name}"
  location = var.region
  tags = local.tags
}

resource "azurerm_storage_account" "storage" {
  name = "${var.env}${var.storage_account_name}"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  static_website {
    index_document          = var.index_document
  }
  tags = local.tags
}

resource "azurerm_cdn_profile" "cdnprofile" {
  name                = "${var.env}-${var.cdn_profile_name}"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  sku = var.cdn_sku
  tags = local.tags
}

resource "azurerm_cdn_endpoint" "cdn" {
  name                = "${var.env}-${var.cdn_endpoint_name}"
  profile_name        = azurerm_cdn_profile.cdnprofile.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  origin_host_header = azurerm_storage_account.storage.primary_web_host
  tags = local.tags
  origin {
    name = var.origin_name
    host_name = azurerm_storage_account.storage.primary_web_host
  }
}