# cicd / github / gcp / terraform

## Description
A collection of terraform scripts a user can use to build the required infrastructure to set up a oidc connection from 
github to gcp artifcat registry
___

## Environment Variables
This list of required and optional variables used by terraform. These variables can be set without their TF_VAR name in 
terraform.tfvars

| Variable                                                | Required | Default                                | Description                                                                     | 
|---------------------------------------------------------|----------|----------------------------------------|---------------------------------------------------------------------------------|
| GOOGLE_APPLICATION_CREDENTIALS                          | true     |                                        | The credentials file downloaded from gcp for a service account with permissions |
| TF_VAR_project_id                                       | true     |                                        | The project id used for resource creation                                       |
| TF_VAR_github_org                                       | true     |                                        | The organization of the code repository                                         |
| TF_VAR_github_repo                                      | true     |                                        | The name of the code repository                                                 |
| TF_VAR_region                                           |          | us-east1                               | The region in which to create resources                                         |                                         
| TF_VAR_github_oidc_service_account                      |          | github-oidc-account                    | The github oidc service account name                                            |
| TF_VAR_github_oidc_workload_identity_pool_id            |          | github-oidc-pool                       | The github oidc pool id                                                         |
| TF_VAR_github_oidc_workload_identity_pool_name          |          | Github OIDC Pool                       | The github oidc pool display name                                               |
| TF_VAR_github_oidc_workload_identity_pool_provider_id   |          | github-oidc-provider                   | The github oidc provider id                                                     |
| TF_VAR_github_oidc_workload_identity_pool_provider_name |          | Github OIDC Provider                   | The github oidc provider display name                                           |
| TF_VAR_github_oidc_workload_identity_pool_provider_url  |          | token.actions.githubusercontent.com    | The github oidc provider url                                                    |
___

## Terraform State Cloud Storage Bucket
This terraform requires an s3 bucket to write it's state out to so that multiple people can work on the same terraform 
if it needs to be updated in the future on an account.

* **Name:** whatever-you-would-like
* **Region:** pick the same region as **TF_VAR_region**

This will be set in the main.tf file as the backend.

**Important Note:** make sure that the terraform role has access to this bucket otherwise terraform init will fail

## Service Account
See: https://ziimm.medium.com/how-to-setup-a-terraform-remote-backend-in-google-cloud-6bb3f1829d5c#:~:text=Terraform%20supports%20a%20number%20of,Cloud%20%E2%80%94%20a%20Cloud%20Storage%20Bucket
for information on how to set up a service account and the backend state storage. Make sure to name the key file:
**gcloud-sa-key.json** and store it in this directory.

## Terraform

### Setup
1. Make a copy of the file ".tmpl/main.tf.tmpl", place it in the parent of the tmpl folder, and replace the %value% 
   values. See the README.md under .tmpl for more information
2. Make a copy of the terraform.tfvars.example file and rename it as terraform.tfvars. Proceed to fill out the required
   variables and any other variables you wish. See the **Environment Variables** section for more details
3. Create the Google Cloud Storage bucket outlined above in **Terraform State Cloud Storage Bucket**
4. Create the required terraform service account outlined in **Service Account**

___
### Run

1. Set the GOOGLE_APPLICATION_CREDENTIALS to the location of your key file
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS=`cat $(pwd)/gcloud-sa-key.json`
   ```
2. Run the init command
   ```bash
   $ terraform init
   
   Initializing the backend...

   Successfully configured the backend "gcs"! Terraform will automatically
   use this backend unless the backend configuration changes.

   Initializing provider plugins...
   - Finding hashicorp/google versions matching "~> 5.3.0"...
   - Installing hashicorp/google v5.3.0...
   - Installed hashicorp/google v5.3.0 (signed by HashiCorp)

   Terraform has created a lock file .terraform.lock.hcl to record the provider
   selections it made above. Include this file in your version control repository
   so that Terraform can guarantee to make the same selections by default when
   you run "terraform init" in the future.

   Terraform has been successfully initialized!

   You may now begin working with Terraform. Try running "terraform plan" to see
   any changes that are required for your infrastructure. All Terraform commands
   should now work.

   If you ever set or change modules or backend configuration for Terraform,
   rerun this command to reinitialize your working directory. If you forget, other
   commands will detect it and remind you to do so if necessary.
   ```
   If you see output similar to above terraform has been initialized successfully.
   If you see output similar to above terraform has been initialized successfully.
3. Once initialized you should run the following:
   ```bash
   $ terraform plan
   ```
   If this is your first time running all the resources will need to be created.
4. Once everything looks good with the terraform plan it's time to run:
   ```bash
   $ terraform apply
   ```
   It will prompt you one last time to check the items and if all looks good type yes
5. If everything went well with the apply step, you should have a fully set up pipeline into GCP Artifact Registry 
   with Github OIDC using Identity Federation in GCP. Please see the workflow folder under cicd/github/gcp/workflow 
   for a fully functioning github workflow file that will login, build, and push the image into Artifact Registry 
   completing the pipeline