provider "aws" {
  region = "us-east-1"
  access_key = "XXX"   ## Input your own Access Key
  secret_key = "XXX"   ## Input your own Secret Key

}

# =================================
variable "bucket-name" {
  default = "<Bucket with Intelligent tiering>"  ## name of the bucket generated 
}
#================================

resource "aws_s3_bucket" "create-s3-bucket" {

  bucket = "${var.bucket-name}"

  acl = "private" ## Standard to private ACL 

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
      days = 1825  ## delete bucket after 5 years of inactive 
    }
    }

  }

  versioning {
    enabled = true ## enabling version for preserve, retrieve, and restore version. 
  }

  tags = {
    Environment: "LifeCycle Controlled" ## Tagging convention to track what this belongs to
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"  ## Apply KMS encryption
      }
    }
  }
}

