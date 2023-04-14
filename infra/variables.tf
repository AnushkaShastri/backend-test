variable "resource_group_name" {
  type        = string
  default     = "resource-group-angular-ping"
  description = "The name of the resource group"
}
variable "region" {
  type        = string
  default     = "East US 2"
  description = "The Azure region used for resources"
}
variable "cdn_profile_name" {
  type        = string
  default     = "cdn-profile-angular-ping"
  description = "The Azure CDN profile name"
}
variable "cdn_endpoint_name" {
  type        = string
  default     = "cdn-endpoint-name-angular-ping"
  description = "The Azure CDN endpoint name"
}
variable "storage_account_name" {
  type = string
  default = "kjangularstorage01"
  description = "The name of the storage account"
}
variable "account_kind" {
  type = string
  default = "StorageV2"
  description = "Each type supports different features and has its own pricing model."
}
variable "account_tier" {
  type = string
  default = "Standard"
  description = "Storage account tier - Basic, Standard or Premium"
}
variable "account_replication_type" {
  type = string
  default = "LRS"
  description = "How your data is replicated in the primary region"
}
variable "index_document" {
  type = string
  default = "index.html"
  description = "Static website where application will start"
}
variable "cdn_sku" {
  type = string
  default = "Standard_Verizon"
  description = "The pricing related information of current CDN profile. Accepted values are Standard_Akamai, Standard_ChinaCdn, Standard_Microsoft, Standard_Verizon or Premium_Verizon. Changing this forces a new resource to be created"
}
variable "origin_name" {
  type = string
  default = "origincdn"
  description = "The name of the origin. This is an arbitrary value. However, this value needs to be unique under the endpoint. Changing this forces a new resource to be created"
}
variable "env" {
  description = "Environment for resource provisioning"
  type = string
  default = "dev"
}
variable "createdBy" {
  type        = string
  description = "Tags attached in each resource contains details of the author, Project ID and Component ID"
}
variable "project" {
  type        = string
  description = "Tags attached in each resource contains details of the author, Project ID and Component ID"
}
variable "projectComponent" {
  type        = string
  description = "Tags attached in each resource contains details of the author, Project ID and Component ID"
}