# Use-Case - Build a intelligent storage solution

## Overview
Terraform scripts and documentation on setting up Intelligent storage tiers for AWS, GCP, and Azure. This will Terraform scripts on configuring general storage and lifecycle management.
If time permits, we may include terraform scripts that include policies for deletion. 
This subfolder aims to include general terraform scripts that can be modified for a user's use case. 
With each institution having its own data use restriction, we aim to allow Research IT to come in and modify the provided configuration to their use cases. 


### Terraform Code for AWS lifecycle Management

```hcl
resource "aws_s3_bucket" "create-s3-bucket" {
  bucket = var.bucket_name

  lifecycle_rule {
    id      = "example-lifecycle-rule"  # Set a name for your rule
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"  # Move objects to STANDARD_IA after 30 days of inactivity
    }

    transition {
      days          = 60
      storage_class = "GLACIER_IR"  # Move objects to GLACIER_IR after 60 days of inactivity
    }

    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"  # Move objects to DEEP_ARCHIVE after 180 days of inactivity
    }

    expiration {
      days = 1825  # Delete the bucket after five years of inactivity
    }
  }
}

```

