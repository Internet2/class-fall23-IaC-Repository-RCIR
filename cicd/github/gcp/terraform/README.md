# cicd / github / gcp / terraform

## Description
A collection of terraform scripts a user can use to build the required infrastructure to set up a oidc connection from 
github to aws ecr 
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
for information on how to set up a service account and the backend state storage

## Terraform

### Setup
1. Make a copy of the file ".tmpl/main.tf.tmpl" and place it in the parent of the tmpl folder.
   ```
___
### Run
