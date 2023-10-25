
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
