# Copied and modified from 
# https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/storage
# 
# Part of Internet2 CLASS 2023 project (i2c23proj)

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "i2c23proj" {
  name     = "${var.prefix}-resources"
  location = var.location
}

resource "azurerm_storage_account" "i2c23proj" {
  name                = "${var.prefix}storageacct"
  resource_group_name = azurerm_resource_group.i2c23proj.name
  location            = azurerm_resource_group.i2c23proj.location

  account_tier                    = "Standard"
  account_kind                    = "StorageV2"
  account_replication_type        = "LRS"
  enable_https_traffic_only       = true
  access_tier                     = "Hot"
#  public_network_access_enabled   = false
  allow_nested_items_to_be_public = true

  blob_properties {
    versioning_enabled = true
    last_access_time_enabled = true
  }
}

#resource "azurerm_role_assignment" "role_assignment" {
#  scope               = azurerm_storage_account.storage_account.id
#  role_definition_id  = join("/", [local.sub, data.azurerm_subscription.primary.subscription_id, local.permission_storage_blob_data_contributor])
#  principal_id        = var.devops_project_object_id
#}

resource "azurerm_storage_management_policy" "i2c23proj" {
  storage_account_id = azurerm_storage_account.i2c23proj.id

  rule {
    name    = "rule1"
    enabled = true
    filters {
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        # Note that to use days since last_access_time to move blobs to cooler storage,
        # last_access_time_enabled must be set to true in the blob_properties block in
        # the storage account above.
        #
        tier_to_cool_after_days_since_last_access_time_greater_than    = var.time_to_cool
        tier_to_archive_after_days_since_last_access_time_greater_than = var.time_to_archive
        delete_after_days_since_last_access_time_greater_than          = var.time_to_delete
      }
      snapshot {
        delete_after_days_since_creation_greater_than = var.snapshot_retention
      }
    }
  }
}

resource "azurerm_storage_container" "i2c23proj" {
  name                  = "${var.prefix}storagecontainer"
  storage_account_name  = azurerm_storage_account.i2c23proj.name
  container_access_type = "blob"
}

