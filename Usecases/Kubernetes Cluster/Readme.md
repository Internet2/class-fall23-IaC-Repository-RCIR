# Use-Case - Build a Kubernetes Cluster

## Step-by-Step Instructions

### Step-1 - Create a cluster in GKE Autopilot mode

- In the Google Cloud Console, create a cluster on the **Kubernetes clusters** page
- Cluster basics: specify a name and region for the cluster, and use default values for other fields:
```
name: ncar-autopilot-cluster-1
region: us-central1
```
- Networking: use default values and continue
- Advanced settings: use default values and continue

### Step-2 - Add a deployment

- From the **Kubernetes clusters** page, select `+DEPLOY`
- In addition to the nginx container, add the NCAR subsetting container.  Select 'Add a container'.
- Choose `Existing container` and select the container `us-central1-docker.pkg.dev/i2class-fall2023-dmdevrie/ncar-transform/ncar-subset` from the Artifact Registry.
- Set the deployment name and app label (these should be the same):
```
Deployment name: ncar-subset
Labels: {
    app: ncar-subset
}
```
- Subsequent changes to the deployment can be made by modifying `deployment.yaml`.  Open a Google Cloud Shell terminal and run the following command to apply the changes:
```
## First retrieve auth credentials for the cluster and verify
gcloud container clusters get-credentials ncar-autopilot-cluster-1 --zone=us-central1
kubectl cluster-info

## Apply deployment yaml
kubectl apply -f deployment.yaml
```