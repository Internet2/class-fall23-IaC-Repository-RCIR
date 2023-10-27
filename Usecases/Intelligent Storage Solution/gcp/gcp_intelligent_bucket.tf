provider "google" {
  project     = "my-project-id"
  region      = "us-central1"
}

resource "google_storage_bucket" "auto-expire2" {
  name          = "intelligent_tiering_bucket3"
  location      = "US"

  public_access_prevention = "enforced" 

  force_destroy = true  /* removes all objects in bucket when delete */

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

# The first resource assigns IAM Binding for the desired roles - these are in addition to the default roles that already exist
#
# Some example roles:
#
#       role = "roles/storage.admin" /* full read/write to all tiers for PI -- maybe the service_account? */
#       role = "roles/storage.objectAdmin"  /* Full read/write to Objects stored in the bucket */
#       role = "roles/storage.objectViewer"  /* Object read only general lab member */
#
# member/members can be user:{emailid}, serviceAccount:{emailid}, group:{emailid}, projectOwner:projectid
#


resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.auto-expire2.name
  role = "roles/storage.admin"
  members = [
     "user:jane@example.com",
     "user:bob@example.com",
  ] 

# Set a condition to expire the additional created roles

  condition {
    title       = "expires_after_2023_10_27"
    description = "Expiring at midnight of 2023-10-27"
    expression  = "request.time < timestamp(\"2023-10-31T00:00:00Z\")"
  }
}


