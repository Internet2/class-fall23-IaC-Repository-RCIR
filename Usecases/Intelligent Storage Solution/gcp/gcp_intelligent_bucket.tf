# Create new storage bucket in the US multi-region
# with standard storage

resource "google_storage_bucket" "auto-expire" {
  name          = "intelligent_tiering_bucket2"
#  project_id    = "my-gcp-project" /* apparently not needed
  location      = "US"

  public_access_prevention = "inherited"  /* inherits rules from organization's policy constraint if it exists , option is "enforced"

  force_destroy = true  /* removes all objects in bucket when delete

  iam_members 
    {
       role = "roles/storage.admin" /* full read/write to all tiers for PI -- maybe the service_account?
       member = "user:spam@example.com"  /* Can be comma delimited list, or by group -> ["group:foo-admins@example.com"]
    }

    {
       role = "roles/storage.admin" /* read/write to all but ARCHIVE for lab manager
       member = "user:spam@example.com"
    }

    {
       role = "roles/storage.objectViewer"  /* read only general lab member
       member = "user:spam@example.com"
    }

  lifecycle_rule = { 
      action = {
        type          = "SetStorageClass"
        storage_class = "STANDARD"
      }
      condition = {
        age                   = "0"
      }
    }
 

  lifecycle_rule = { 
     condition = {
        age                   = "30"
      }
      action = {
        type          = "SetStorageClass"
        storage_class = "NEARLINE"
      }
    }
 

  lifecycle_rule = {
     condition = {
        age                   = "90"
      }
      action = {
        type          = "SetStorageClass"
        storage_class = "COLDLINE"
      }
    }
 

  lifecycle_rule = {
     condition = {
        age                   = "365"
      }
      action = {
        type          = "SetStorageClass"
        storage_class = "ARCHIVE"
      }
    }
  

  lifecycle_rule = {
      action = {
        type          = "Delete"
      }
      condition = {
        age                   = "1826" /* Delete afer 5 years
      }
    }
    

  versioning {
    enabled        = true
  }

  encryption {
    default_kms_key_name = string /* The id of a Cloud KMS key that will be used to encrypt objects inserted into this bucket, if no encryption method is specified
  }

/*
 * Optionally we could use autoclass
 *
 * autoclass = {
 *    enabled = true
 *    terminal_storage_class = "ARCHIVE"
 * }
*/
}
