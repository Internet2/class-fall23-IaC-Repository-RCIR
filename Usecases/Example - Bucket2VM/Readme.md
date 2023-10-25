# Use-Case - Create Storage Bucket, Import Data from Google Drive, and Move Data to a VM on GCP/AWS

## Step-by-Step Instructions

### Step 1 - Ensure Project Availability

- Ensure you have an active project on GCP or AWS with the necessary permissions to create storage buckets and VM instances.

### Step 2 - Install Required Software

- Install Terraform v0.14+
- Install Google Cloud SDK (for GCP) or AWS CLI (for AWS)
- Install `gsutil` (for GCP)
- Install Bash

### Step 3 - Initialize Terraform

```bash
terraform init
```

### Step 4 - Apply Terraform Configuration for Storage and VM

```bash
terraform apply
```

#### Terraform Code for AWS (storage-vm.tf)

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "my-data-bucket"
  acl    = "private"
}

resource "aws_instance" "data_vm" {
  ami           = "ami-0123456789abcdef0"
  instance_type = "t2.micro"
  tags = {
    Name = "Data_VM"
  }
}
```

#### Terraform Code for GCP (storage-vm.tf)

```hcl
provider "google" {
  credentials = file("<PATH_TO_SERVICE_ACCOUNT_JSON>")
  project     = "<PROJECT_ID>"
  region      = "us-central1"
}

resource "google_storage_bucket" "data_bucket" {
  name     = "my-data-bucket"
  location = "US"
}

resource "google_compute_instance" "data_vm" {
  name         = "data-vm"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
}
```

### Step 5 - Import Data from Google Drive to Bucket

#### For GCP:

```bash
gsutil -m cp -r [GOOGLE_DRIVE_FOLDER_PATH] gs://my-data-bucket/
```

#### For AWS:

```bash
aws s3 cp [GOOGLE_DRIVE_FOLDER_PATH] s3://my-data-bucket/ --recursive
```

### Step 6 - Move Data to VM

#### For GCP:

```bash
gsutil cp gs://my-data-bucket/* /path/on/vm
```

#### For AWS:

```bash
aws s3 cp s3://my-data-bucket/ /path/on/vm --recursive
```

### Step 7 - Troubleshooting

- **Issue**: Terraform fails to create resources.
  - **Solution**: Check your internet connection and permissions.

- **Issue**: Data transfer fails at any step.
  - **Solution**: Make sure you have proper access rights to Google Drive, the storage bucket, and the VM.

---

### Best Practices:

- Always encrypt your bucket for added security.
- Implement IAM roles and firewall rules to restrict access.
- Audit and monitor activity to catch any unauthorized access.

