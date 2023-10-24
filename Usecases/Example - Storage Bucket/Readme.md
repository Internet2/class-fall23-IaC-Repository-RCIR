# Use-Case - Deploy a Simple and Secure Storage Bucket on GCP/AWS that can be use to move and store research data from google drive 

## Step-by-Step Instructions

### Step 1 - Ensure Project Availability

- Make sure you have an active project on GCP or AWS with the necessary permissions to create storage resources.

### Step 2 - Install Required Software

- Install Terraform v0.14+
- Install gsutil for GCP or AWS CLI for AWS

### Step 3 - Initialize Terraform

```bash
terraform init
```

### Step 4 - Apply Terraform Configuration

```bash
terraform apply
```

#### Terraform Code for AWS (storage.tf)

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "research_data_bucket" {
  bucket = "my-research-data-bucket"
  acl    = "private"
}
```

#### Terraform Code for GCP (storage.tf)

```hcl
provider "google" {
  credentials = file("<PATH_TO_SERVICE_ACCOUNT_JSON>")
  project     = "<PROJECT_ID>"
  region      = "us-central1"
}

resource "google_storage_bucket" "research_data_bucket" {
  name     = "my-research-data-bucket"
  location = "US"
}
```

### Step 5 - Copy Data from Google Drive

#### For GCP:

```bash
gsutil -m cp -r [GOOGLE_DRIVE_FOLDER_PATH] gs://my-research-data-bucket/
```

#### For AWS:

```bash
aws s3 cp [GOOGLE_DRIVE_FOLDER_PATH] s3://my-research-data-bucket/ --recursive
```

### Step 6 - Troubleshooting

- **Issue**: Terraform initialization fails.
  - **Solution**: Verify your internet connection.
  
- **Issue**: Data copy fails.
  - **Solution**: Make sure you have the correct permissions for both Google Drive and the storage bucket.

---

### Best Practices:

- Always encrypt your bucket for added security.
- Implement Identity and Access Management (IAM) policies to tightly control access.
- Regularly audit and monitor activity to detect any unauthorized access or anomalies.
