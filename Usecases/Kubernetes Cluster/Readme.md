# Use-Case - Build a Kubernetes Cluster

## Step-by-Step Instructions

### Step-1 - Create a cluster in GKE Standard mode

- In the Google Cloud Console, create a cluster on the **Kubernetes clusters** page
- Cluster basics: specify a name and region for the cluster, and use default values for other fields:
```
name: ncar-autopilot-cluster-1
zone: us-central1-a
```
- Networking: use default values and continue
- Advanced settings: 