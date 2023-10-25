# Use-Case - Deploy a Jupyter Notebook on a Kubernetes Cluster in GCP/AWS

## Step-by-Step Instructions

### Step 1 - Ensure Project Availability

- Verify you have an active project on GCP or AWS with the necessary permissions to manage Kubernetes clusters and deploy applications.

### Step 2 - Install Required Software

- Install Terraform v0.14+
- Install `kubectl`
- Install Helm
- Install Bash

### Step 3 - Initialize Terraform

```bash
terraform init
```

### Step 4 - Apply Terraform Configuration to Create Kubernetes Cluster

```bash
terraform apply
```

#### Terraform Code for AWS (eks.tf)

```hcl
provider "aws" {
  region = "us-west-2"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-cluster"
  cluster_version = "1.21"
  subnets         = ["subnet-abcde012", "subnet-bcde012a"]
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

#### Terraform Code for GCP (gke.tf)

```hcl
provider "google" {
  credentials = file("<PATH_TO_SERVICE_ACCOUNT_JSON>")
  project     = "<PROJECT_ID>"
  region      = "us-central1"
}

module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google"
  project_id             = "<PROJECT_ID>"
  name                   = "my-cluster"
  regional               = false
  zones                  = ["us-central1-a", "us-central1-b"]
  initial_node_count     = 1
}
```

### Step 5 - Configure `kubectl`

- After cluster creation, configure `kubectl` to use the new cluster.

### Step 6 - Install JupyterHub using Helm

```bash
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update
helm install my-release jupyterhub/jupyterhub --version=0.11.1 --values config.yaml
```

### Step 7 - Access JupyterHub

- After the deployment is complete, you can access JupyterHub via the external IP provided.

### Step 8 - Troubleshooting

- **Issue**: Terraform fails to create the Kubernetes cluster.
  - **Solution**: Verify your internet connection and permissions.

- **Issue**: Helm fails to install JupyterHub.
  - **Solution**: Ensure Helm is correctly installed and that you can connect to the Kubernetes cluster.

---

### Best Practices:

- Always ensure the Kubernetes cluster and deployed applications are securely configured.
- Implement RBAC policies to control access to the cluster and applications.
- Monitor cluster and application logs for any unauthorized access or anomalies.

