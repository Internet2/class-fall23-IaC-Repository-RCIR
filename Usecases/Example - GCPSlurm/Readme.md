# Use-Case - Create and Run a Slurm Cluster on GCP using Terraform and Ansible

## Step-by-Step Instructions

### Step 1 - Ensure Project Availability

- Make sure you have an active GCP project with the necessary permissions to create VM instances and manage networking.

### Step 2 - Install Required Software

- Install Terraform v0.14+
- Install Ansible v2.9+
- Install Google Cloud SDK
- Install Bash

### Step 3 - Initialize Terraform

```bash
terraform init
```

### Step 4 - Apply Terraform Configuration for Slurm Cluster

```bash
terraform apply
```

#### Terraform Code for GCP (slurm-cluster.tf)

```hcl
provider "google" {
  credentials = file("<PATH_TO_SERVICE_ACCOUNT_JSON>")
  project     = "<PROJECT_ID>"
  region      = "us-central1"
}

resource "google_compute_instance" "slurm_controller" {
  name         = "slurm-controller"
  machine_type = "n1-standard-2"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
}

resource "google_compute_instance" "slurm_worker" {
  count        = 3
  name         = "slurm-worker-${count.index}"
  machine_type = "n1-standard-2"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
}
```

### Step 5 - SSH into Slurm Controller VM

- SSH into the Slurm controller VM to proceed with Ansible configuration.

### Step 6 - Run Ansible Playbook for Slurm Configuration

Navigate to your Ansible directory and execute:

```bash
ansible-playbook slurm-setup.yml
```

#### Ansible Code (slurm-setup.yml)

```yaml
---
- name: Configure Slurm Controller
  hosts: slurm_controller
  become: yes
  roles:
    - role: galaxyproject.slurm

- name: Configure Slurm Workers
  hosts: slurm_workers
  become: yes
  roles:
    - role: galaxyproject.slurm
```

### Step 7 - Validate Slurm Cluster

- Validate that the Slurm cluster is operational by running some test jobs.

### Step 8 - Troubleshooting

- **Issue**: Terraform fails to create the Slurm cluster.
  - **Solution**: Check your internet connection and permissions.
  
- **Issue**: Ansible playbook fails during execution.
  - **Solution**: Validate that the Ansible inventory is properly configured and that you can SSH into all nodes.

---

### Best Practices:

- Secure the VM instances using firewall rules and IAM policies.
- Monitor the cluster for any performance or security issues.
- Regularly update the software on the VM instances.

