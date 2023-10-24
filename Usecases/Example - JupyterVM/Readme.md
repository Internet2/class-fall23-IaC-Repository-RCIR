# Use-Case - Deploy a Jupyter Notebook on a Single VM

## Step-by-Step Instructions

### Step 1 - Ensure that projects are available on GCP/AWS (whichever system you are using)

- Make sure you have an active project on GCP or AWS and you have the necessary permissions to create resources.

### Step 2 - Install Required Software

- Install Terraform v0.14+
- Install Ansible v2.9+
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
resource "aws_instance" "jupyter_vm" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "Jupyter_VM"
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
resource "google_compute_instance" "jupyter_vm" {
  name         = "jupyter-vm"
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

### Step 5 - Navigate to Ansible Directory

```bash
cd ansible
```

### Step 6 - Run Ansible Playbook

```bash
ansible-playbook setup.yml
```

#### Ansible Code (jupyter.yml)

```yaml
---

- name: Setup Jupyter Notebook
  hosts: jupyter_vm
  become: yes
  tasks:
    - name: Update and upgrade apt packages
      apt:
        update_cache: yes
        upgrade: yes
    - name: Install pip
      apt:
        name: python3-pip
        state: present
    - name: Install Jupyter Notebook
      pip:
        name: notebook
        executable: pip3
```

### Step 7 - Navigate to Bash Directory

```bash
cd bash
```

### Step 8 - Run Bash Script

```bash
./start_jupyter.sh
```

#### Bash Code (start_jupyter.sh)

```bash
#!/bin/bash
jupyter notebook --ip=0.0.0.0 --no-browser
```

### Step 9 - Troubleshooting

- **Issue**: Terraform initialization fails.
  - **Solution**: Check your internet connection.
- **Issue**: Ansible playbook fails.
  - **Solution**: Make sure you are in the Ansible directory and the inventory file is correctly configured.
