provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "research_data_bucket" {
  bucket = "my-research-data-bucket"
  acl    = "private"
}