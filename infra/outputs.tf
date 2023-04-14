output "cdn_endpoint" {
  value = "https://${azurerm_cdn_endpoint.cdn.fqdn}"
  description = "CDN Endpoint Hostname"
}
output "storage_blob" {
    value = "https://${azurerm_storage_account.storage.primary_web_host}"
    description = "Location/Endpoint of the storage blob"
}
output "static_website_url" {
    value = azurerm_cdn_endpoint.cdn.origin
    description = "CDN Origin Hostname"
}
output "storage_account_name" {
    value = azurerm_storage_account.storage.name
    description = "Name of the storage account"
}