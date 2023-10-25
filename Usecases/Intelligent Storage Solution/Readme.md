# Use-Case - Build an intelligent storage solution

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

### Terraform Code for AWS enabling version on S3 
Enabling versioning on an Amazon S3 (Simple Storage Service) bucket is important for several reasons, particularly for data integrity, recovery,compliance,
Accidental Deletion and Overwrites, Data Recovery, Legal and Compliance Requirements, Audits, and Backup and or Restores.
It's important to note that enabling versioning in S3 can increase storage costs because each version of an object is retained, and you are billed based on storage usage. You should carefully manage your versioned objects and implement lifecycle policies to control the retention and storage costs effectively.

```hcl
provider "aws" {
  region = "us-east-1"  # Change to your desired AWS region
}

resource "aws_s3_bucket" "example_bucket" { 
  bucket = "your-unique-bucket-name"  # Change to your desired bucket name
  acl    = "private"

  versioning {
    enabled = true
  }
}
```
### Terraform Code for AWS setting up ACL config for S3 

```hcl
provider "aws" {
  region = "us-east-1"  # Change to your desired AWS region
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "your-unique-bucket-name"  # Change to your desired bucket name

  acl = "private"  # Set the desired ACL. Possible values are: private, public-read, public-read-write, authenticated-read, and aws-exec-read

  # Define a bucket policy to allow specific IAM roles access to the bucket
  policy = <<POLICY
{
  "Version": "xxxx-xx-xx",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": ["arn:aws:iam::YOUR_ACCOUNT_ID:role/Role1", "arn:aws:iam::YOUR_ACCOUNT_ID:role/Role2"] ## replace the ARNs of the IAM roles that should have access to the bucket.
      },
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::your-unique-bucket-name/*",
        "arn:aws:s3:::your-unique-bucket-name"
      ]
    }
  ]
}
POLICY
}
```

