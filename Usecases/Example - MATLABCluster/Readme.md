# Use-Case - Deploy a MATLAB Cluster with Containers on GCP/AWS

## Step-by-Step Instructions

### Step 1 - Ensure Project Availability

- Make sure you have an active project on GCP or AWS with the necessary permissions to create VM instances and manage containers.

### Step 2 - Install Required Software

- Install Terraform v0.14+
- Install Docker
- Install Bash

### Step 3 - Initialize Terraform

```bash
terraform init
```

### Step 4 - Apply Terraform Configuration

```bash
terraform apply
```

#### Terraform Code for AWS (cluster.tf)

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "matlab_vm" {
  count         = 3
  ami           = "ami-0123456789abcdef0"
  instance_type = "m5.large"
  tags = {
    Name = "MATLAB_VM-${count.index}"
  }
}
```

#### Terraform Code for GCP (cluster.tf)

```hcl
provider "google" {
  credentials = file("<PATH_TO_SERVICE_ACCOUNT_JSON>")
  project     = "<PROJECT_ID>"
  region      = "us-central1"
}

resource "google_compute_instance" "matlab_vm" {
  count        = 3
  name         = "matlab-vm-${count.index}"
  machine_type = "n1-standard-2"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
}
```

### Step 5 - SSH into Each VM

- Obtain the IP addresses of the VM instances and SSH into each one.

### Step 6 - Install Docker on VMs

```bash
sudo apt-get update
sudo apt-get install docker.io
```

### Step 7 - Deploy MATLAB Container

On each VM, run the following to deploy MATLAB:

```bash
docker run --rm -it mathworks/matlab
```

### Step 8 - Troubleshooting

- **Issue**: Terraform fails to create the VM instances.
  - **Solution**: Verify your internet connection and permissions.

- **Issue**: Docker installation or MATLAB container deployment fails.
  - **Solution**: Make sure you have sudo privileges and that the VM has internet access.

---

### Best Practices:

- Secure the VM instances with appropriate firewall rules and IAM policies.
- Use network policies to restrict communication between containers as needed.
- Regularly update the MATLAB container to keep it secure.

