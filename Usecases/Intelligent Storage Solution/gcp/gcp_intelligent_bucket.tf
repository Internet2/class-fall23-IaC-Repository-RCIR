resource "google_storage_bucket" "auto-expire2" {
  name          = "intelligent_tiering_bucket3"
  location      = "US"

  public_access_prevention = "enforced" 

  force_destroy = true  /* removes all objects in bucket when delete */


#  iam_members { 
#    {
#       role = "roles/storage.admin" /* full read/write to all tiers for PI -- maybe the service_account? */
#       member = "ikaufman@ucsd.edu"  /* Can be comma delimited list, or by group -> ["group:foo-admins@example.com"] */
#    }
#
#    {
#       role = "roles/storage.admin" /* read/write to all but ARCHIVE for lab manager */
#       member = "user:spam@example.com"
#    }
#
#    {
#       role = "roles/storage.objectViewer"  /* read only general lab member */
#       member = "user:spam@example.com"
#    }
#  }

  lifecycle_rule  { 
      condition  {
        age                   = 0
      }
      action  {
        type          = "SetStorageClass"
        storage_class = "Standard"
      }
    }
 

  lifecycle_rule  { 
     condition  {
        age                   = 30
      }
      action  {
        type          = "SetStorageClass"
        storage_class = "Nearline"
      }
    }
 

  lifecycle_rule  {
     condition  {
        age                   = 90
      }
      action  {
        type          = "SetStorageClass"
        storage_class = "Coldline"
      }
    }
 

  lifecycle_rule  {
     condition  {
        age                   = 365
      }
      action  {
        type          = "SetStorageClass"
        storage_class = "Archive"
      }
    }
  

  lifecycle_rule  {
      condition  {
        age                   = 1826 /* Delete after 5 years */
      }
      action  {
        type          = "Delete"
      }
    }
    

  versioning {
    enabled        = true
  }

#  encryption {
#    default_kms_key_name = string /* The id of a Cloud KMS key that will be used to encrypt objects inserted into this bucket, if no encryption method is specified */
#  }

}
