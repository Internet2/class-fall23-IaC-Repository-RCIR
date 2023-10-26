# Use-Case - Build an intelligent storage solution

## Overview
Terraform scripts and documentation on setting up Intelligent storage tiers for AWS, GCP, and Azure. This will Terraform scripts on configuring general storage and lifecycle management.
If time permits, we may include terraform scripts that include policies for deletion. 
This subfolder aims to include general terraform scripts that can be modified for a user's use case. 
With each institution having its own data use restriction, we aim to allow Research IT to come in and modify the provided configuration to their use cases. 

## Step-by-Step Instructions

### Step 1 - Ensure Project Availability

- Make sure you have an active GCP project with the required permissions to create and manage storage buckets.

### Step 2 - Install Required Software

- Install Terraform v0.14+
- Install Google Cloud SDK
- Install Bash

### Step 3 - Initialize Terraform

\`\`\`bash
terraform init
\`\`\`

### Step 4 - Apply Terraform Configuration for Intelligent Storage Bucket

\`\`\`bash
terraform apply
\`\`\`

#### Terraform Code for GCP (intelligent_storage.tf)

```hcl
resource "google_storage_bucket" "auto-expire2" {
  name          = "intelligent_tiering_bucket3"
  location      = "US"
  force_destroy = true  /* removes all objects in bucket when delete */
  public_access_prevention = "enforced"

  // Uncomment to define IAM members and permissions
  // iam_members { 
  //   {
  //      role = "roles/storage.admin"
  //      member = ""
  //   }
  //   // More IAM roles...
  // }

  // Lifecycle rules to automatically transition storage classes
  lifecycle_rule {
    condition {
      age = 0
    }
    action {
      type          = "SetStorageClass"
      storage_class = "Standard"
    }
  }
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type          = "SetStorageClass"
      storage_class = "Nearline"
    }
  }
  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type          = "SetStorageClass"
      storage_class = "Coldline"
    }
  }
  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type          = "SetStorageClass"
      storage_class = "Archive"
    }
  }
  lifecycle_rule {
    condition {
      age = 1826  /* Delete after 5 years */
    }
    action {
      type          = "Delete"
    }
  }

  // Enable versioning
  versioning {
    enabled = true
  }

  // Uncomment to enable encryption
  // encryption {
  //   default_kms_key_name = string
  // }
}
```
#### Terraform Code for AWS (intelligent_storage_S3.tf)

```hcl
provider "aws" {
  region     = "us-east-1"
  access_key = "XXX"  // Input your own Access Key
  secret_key = "XXX"  // Input your own Secret Key
}

resource "aws_s3_bucket" "create-s3-bucket" {
  bucket = var.bucket-name
  acl    = "private"

  lifecycle_rule {
    id      = "LifeCycle Name"
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER_IR"
    }
    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }

    expiration {
      days = 1825  // Delete bucket after 5 years
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    Environment = "LifeCycle Controlled"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}
```
### Step 5 - Validate Configuration

- Validate that the bucket has been created and configured as per your requirements.

### Step 6 - Troubleshooting

- **Issue**: Terraform fails to create the bucket.
  - **Solution**: Check your internet connection, permissions, and GCP API access.

- **Issue**: Lifecycle rules are not working as expected.
  - **Solution**: Validate the lifecycle conditions and actions in the Terraform script.

---

### Best Practices:

- Always encrypt sensitive data.
- Implement IAM roles to restrict access.
- Regularly audit and monitor bucket for any unauthorized access or anomalies.

