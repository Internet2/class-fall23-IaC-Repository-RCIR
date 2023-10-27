# Description

This is a nascent implementation of an intelligent storage solution on Microsoft Azure,
managed by Terraform.
The current feature set is limited to lifecycle management, in which the the access tier 
of blob storage is automatically changed
from hot to cool to archive based on the last modified time of the blob.

Data are stored in an Azure storage container, which belongs to a storage account, 
to which management policies are applied. 
All these are resources that need to be created.
Below are relevant sections from `main.tf`; variables are defined in `variables.tf`.


## Create resource group

Presumably other resources (compute, other storage accounts and containers, etc.)
could be added to this group.

```
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "i2c23proj" {
  name     = "${var.prefix}-resources"
  location = var.location
}
```


## Create storage account and its management policy

Using the last access time of a blob rather than the modification time as the determinant of
when to move a blob to a cooler tier might make more sense.
However, this apparently requires that the
"last access time based tracking policy must be enabled before using its specific actions 
in object lifecycle management policy," (the error message returned from `tf apply`),
but it's not obvious how to do that. 

Also, Azure storage has hot, cool, cold and archive tiers, but the strings to set these
values in Terraform (such as `tier_to_cool_after_days_since_modification_greater_than`) 
seem not to have a cold analog.


```
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
#  enable_last_access_tracking = true
}


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
        tier_to_cool_after_days_since_modification_greater_than    = var.time_to_cool
        tier_to_archive_after_days_since_modification_greater_than = var.time_to_archive
        delete_after_days_since_modification_greater_than          = var.time_to_delete
      }
      snapshot {
        delete_after_days_since_creation_greater_than = var.snapshot_retention
      }
    }
  }
}
```


## Create storage container
```
resource "azurerm_storage_container" "i2c23proj" {
  name                  = "${var.prefix}storagecontainer"
  storage_account_name  = azurerm_storage_account.i2c23proj.name
  container_access_type = "blob"
}
```





# Limitations

Owing to the short development time, it was not possible to test the lifecycle policy, 
although it can be confirmed in the Azure portal.


# Possible enhancements

Data in an Azure Storage container is encrypted by 
[default](https://learn.microsoft.com/en-us/azure/storage/common/storage-service-encryption)
using 256-bit AES encryption and is FIPS 140-2 compliant.
By default, this uses Microsoft-managed keys scoped to the storage account;
you can specify customer-provided keys scoped to a container or an individual blob.

There is a StackOverflow 
[discussion](https://stackoverflow.com/questions/73741756/disabling-allow-public-blob-access-using-terraform) about disabling public blob access in Terraform.
However, explicitly disabling this interfered with creating a storage container. 

