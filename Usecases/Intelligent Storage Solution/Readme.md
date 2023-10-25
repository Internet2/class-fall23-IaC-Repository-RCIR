# Use-Case - Build a intelligent storage solution

## Overview
Terraform scripts and documentation on setting up Intelligent storage tiers for AWS, GCP, and Azure. This will Terraform scripts on configuring general storage and lifecycle management.
If time permits, we may include terraform scripts that include policies for deletion. 
This subfolder aims to include general terraform scripts that can be modified for a user's use case. 
With each institution having its own data use restriction, we aim to allow Research IT to come in and modify the provided configuration to their use cases. 


### Terraform Code for AWS lifecycle Management

```hcl
resource "aws_s3_bucket" "create-s3-bucket" {

  bucket = "${var.bucket-name}"
  lifecycle_rule {
    id = "<LifeCycle Name>"   ## set name for your rule
    enabled = true
    transition {
      days          = 30      
      storage_class = "STANDARD_IA" ## move your bucket to a standard_IA after 30 days of inactivity
    }

    transition {
      days          = 60
      storage_class = "GLACIER_IR"  ## Move your bucket to a Glacier after 30 days of inactivity
    }
    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE" ## Move your bucket to a Deep Glacier after 180 days of inactivity
    }

    expiration {
      days = 1825  ## delete bucket after five years of inactive 
    }
    }
```

