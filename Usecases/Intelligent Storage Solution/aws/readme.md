
### Terraform Code for AWS lifecycle Management
Here, we will enable the lifecycle management rule where transition blocks will specify the conditions under which objects in the bucket should be transitioned to different storage classes. The code configures three transitions:

After 30 days of inactivity, objects are moved to the "STANDARD_IA" storage class.
After 60 days of inactivity, objects are moved to the "GLACIER_IR" storage class.
After 180 days of inactivity, objects are moved to the "DEEP_ARCHIVE" storage class.

There is also an expiration block that will delete the objects that are inactive for 1825 days (5 years)

```hcl
resource "aws_s3_bucket" "create-s3-bucket" {
  bucket = BucketName

  lifecycle_rule {
    id      = "example-lifecycle-rule"  # Set a name for your rule
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"  # Move objects to STANDARD_IA after 30 days of inactivity
    }

    transition {
      days          = 90
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
Enabling versioning on an Amazon S3 (Simple Storage Service) bucket is important for several reasons, particularly for data integrity, recovery, compliance,
Accidental Deletion and Overwrites, Data Recovery, Legal and Compliance Requirements, Audits, and Backup and/or Restores.
It's important to note that enabling versioning in S3 can increase storage costs because each version of an object is retained, and you are billed based on storage usage. You should carefully manage your versioned objects and implement lifecycle policies to control retention and storage costs effectively.

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
### Terraform Code for AWS setting up bucket policy config for S3 
Access Control Lists (ACLs) for storage buckets, such as those in Amazon S3 or other cloud storage services, are crucial for ensuring the security and proper management of your data. ACLs define who can access your bucket, their access level, and under what conditions.
this snippet creates an S3 bucket with a default "private" ACL and then attaches a bucket policy that grants permissions for "GetObject" and "DeleteObject" actions to IAM users or roles with ARNs containing "arn:aws:iam::*:user/admin." Other users will not have these privileges unless their ARN matches this specific pattern, effectively restricting access to a specific group of users or roles.
```hcl
resource "aws_s3_bucket" "create-s3-bucket" {

  bucket = "kevintestclassadvanced"

  acl = "private"

resource "aws_s3_bucket_policy" "example_bucket_policy" {
  bucket = aws_s3_bucket.create-s3-bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = "s3:GetObject",
        Resource = aws_s3_bucket.create-s3-bucket.arn,
        Condition = {
          StringEquals = {
            "aws:Requester" = "arn:aws:iam::*:user/admin"
          }
        }
      },
      {
        Effect = "Allow",
        Principal = "*",
        Action = "s3:DeleteObject",
        Resource = aws_s3_bucket.create-s3-bucket.arn,
        Condition = {
          StringEquals = {
            "aws:Requester" = "arn:aws:iam::*:user/admin"
          }
        }
      }
    ]
  })
}
```
### Enabling KMS encryption on an S3 bucket
```hcl
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
```
