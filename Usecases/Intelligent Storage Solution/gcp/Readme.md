
### Terraform Code for GCP lifecycle Management
Here, we will enable the lifecycle management rule where transition blocks will specify the conditions under which objects in the bucket should be transitioned to different storage classes. The code configures three transitions:

The initial storage class at creation/upload of the objects are "STANDARD"
After 30 days of inactivity, objects are moved to the "NEARLINE" storage class.
After 60 days of inactivity, objects are moved to the "COLDLINE" storage class.
After 180 days of inactivity, objects are moved to the "ARCHIVE" storage class.

There is also an expiration block that will delete the objects that are inactive for 1825 days (5 years)

The line 'public_access_prevention = "enforced"' sets a default privacy policy of private. Option is "inherited" which inherits the default organizaiton policy 

The line "force_destroy = true" will force objects to be deleted when the bucket is deleted

The code block for "versioning" allows for snapshots of the objects to exist so that the original content is stored when changes are applied to the object

```hcl
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
}

```

### Enabling KMS encryption on a GCP bucket
```hcl
  encryption {
    default_kms_key_name = string /* The id of a Cloud KMS key that will be used to encrypt objects inserted into this bucket, if no encryption method is specified */
  }

```
...
### Terraform Code for GCP setting up bucket policy config for buckets 
Access Control Lists (ACLs) for storage buckets, such as those in GCP or other cloud storage services, are crucial for ensuring the security and proper management of your data. ACLs define who can access your bucket, their access level, and under what conditions.
The resource assigns IAM Binding for the desired roles - these are in addition to the default roles that already exist

Some example roles:

       role = "roles/storage.admin" /* full read/write to all tiers for PI -- maybe the service_account? */
       role = "roles/storage.objectAdmin"  /* Full read/write to Objects stored in the bucket */
       role = "roles/storage.objectViewer"  /* Object read only general lab member */

member/members can be user:{emailid}, serviceAccount:{emailid}, group:{emailid}, projectOwner:projectid

The condition block allows you to set automatic expiration of access to the members created

These members are in addition to any defaults set by the organzation

The".name" automatically pulls the name from the resource above.

```hcl
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

```
### Enabling KMS encryption on a GCP bucket
```hcl
  encryption {
    default_kms_key_name = string /* The id of a Cloud KMS key that will be used to encrypt objects inserted into this bucket, if no encryption method is specified */
  }

```

