# Use-Case - Deploy a VM with Stata Container and Mount a 500GB Disk on AWS/GCP

## Step-by-Step Instructions

### Step 1 - Ensure Project Availability

- Confirm you have an active project on GCP or AWS with the necessary permissions to create VM instances, manage containers, and manage storage.

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

#### Terraform Code for AWS (compute.tf,disk.tf)

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "stata_vm" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "Stata_VM"
  }
}

resource "aws_ebs_volume" "stata_disk" {
  availability_zone = "us-west-2a"
  size              = 500
  tags = {
    Name = "Stata_Disk"
  }
}
```

#### Terraform Code for GCP (compute.tf,disk.tf)

```hcl
provider "google" {
  credentials = file("<PATH_TO_SERVICE_ACCOUNT_JSON>")
  project     = "<PROJECT_ID>"
  region      = "us-central1"
}

resource "google_compute_instance" "stata_vm" {
  name         = "stata-vm"
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

resource "google_compute_disk" "stata_disk" {
  name  = "stata-disk"
  type  = "pd-standard"
  size  = 500
  zone  = "us-central1-a"
}
```

### Step 5 - SSH into VM

- Obtain the IP address of the VM instance and SSH into it.

### Step 6 - Install Docker on VM

```bash
sudo apt-get update
sudo apt-get install docker.io
```

### Step 7 - Deploy Stata Container

```bash
docker run -it --name my-stata-container kylebarron/stata
```

### Step 8 - Mount 500GB Disk

#### For AWS:

```bash
sudo mkfs -t ext4 /dev/xvdf
sudo mkdir /mnt/stata-disk
sudo mount /dev/xvdf /mnt/stata-disk
```

#### For GCP:

```bash
sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
sudo mkdir -p /mnt/stata-disk
sudo mount -o discard,defaults /dev/sdb /mnt/stata-disk
```

### Step 9 - Troubleshooting

- **Issue**: Terraform initialization fails.
  - **Solution**: Verify your internet connection.
  
- **Issue**: Docker installation fails.
  - **Solution**: Ensure you have sudo privileges and that the VM has internet access.

- **Issue**: Disk mounting fails.
  - **Solution**: Check the disk is properly initialized and you have the right permissions.

---

### Best Practices:

- Ensure that both the VM and the Stata container are securely configured.
- Implement IAM roles and firewall rules to tightly control access.
- Regularly update both the VM and the container to keep them secure.

