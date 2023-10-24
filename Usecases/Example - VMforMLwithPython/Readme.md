# Use-Case - Deploy a VM with a Python Container for ML Applications on GCP/AWS

## Step-by-Step Instructions

### Step 1 - Ensure Project Availability

- Ensure you have an active project on GCP or AWS with the necessary permissions to create VM instances and manage containers.

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

#### Terraform Code for AWS (compute.tf)

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "ml_vm" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "ML_VM"
  }
}
```

#### Terraform Code for GCP (compute.tf)

```hcl
provider "google" {
  credentials = file("<PATH_TO_SERVICE_ACCOUNT_JSON>")
  project     = "<PROJECT_ID>"
  region      = "us-central1"
}

resource "google_compute_instance" "ml_vm" {
  name         = "ml-vm"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = "default"
  }
}
```

### Step 5 - SSH into VM

- Obtain the IP address of the VM instance and SSH into it.

### Step 6 - Install Docker on VM

```bash
sudo apt-get update
sudo apt-get install docker.io
```

### Step 7 - Deploy Python Container

```bash
docker run -it --name my-ml-container python:3.8 bash
```

Inside the container, you can then proceed to install any ML libraries you need:

```bash
pip install scikit-learn pandas numpy
```

### Step 8 - Troubleshooting

- **Issue**: Terraform initialization fails.
  - **Solution**: Verify your internet connection.
  
- **Issue**: Docker installation fails.
  - **Solution**: Ensure you have sudo privileges and the VM has internet access.

---

### Best Practices:

- Always ensure that the deployed VM and container are securely configured.
- Use IAM roles and firewall rules to restrict access to the VM and the container.
- Regularly update the VM and container to patch any security vulnerabilities.

