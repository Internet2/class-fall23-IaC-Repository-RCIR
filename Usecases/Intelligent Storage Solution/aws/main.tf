resource "aws_s3_bucket" "create-s3-bucket" {

  bucket = "kevintestclassadvanced"

  acl = "private"

  lifecycle_rule {
    id = "archive"
    enabled = true
    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }

    expiration {
      days          = 1825
    }

  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
