# cicd / github / aws / terraform

## Description
A collection of terraform scripts a user can use to build the required infrastructure to set up a oidc connection from github to aws ecr 
___

## Environment Variables
This list of required and optional variables used by terraform

| Variable                           | Required | Default                                   | Description                                                                                      | 
|------------------------------------|----------|-------------------------------------------|--------------------------------------------------------------------------------------------------|
| AWS_PROFILE                        | true     | default                                   | The profile set to the terraform role configuration                                              |
| TF_VAR_account_id                  | true     |                                           | The account id where the terraform will run its actions                                          |
| TF_VAR_github_org                  | true     |                                           | The name of the github org (or personal account)                                                 |
| TF_VAR_github_repo_name            | true     |                                           | The name of the github repository. Will also be used for the name of the ecr repository          |
| TF_VAR_region                      |          | us-east-1                                 | The region where any resources for this terraform will be built                                  |
| TF_VAR_role_name                   |          | GithubOIDCTerraform                       | The name of the terraform role (at the end of the arn)                                           |
| TF_VAR_github_oidc_role_name       |          | GithubOIDCRole                            | The name of the role used for github oidc                                                        |
| TF_VAR_github_oidc_ecr_policy_name |          | GithubOIDCEcrPolicy                       | The name of the policy used to give oidc access to ecr                                           |
| TF_VAR_github_oidc_event_access    |          | ref:refs/tags/*                           | The string used to filter the allowed github event actions in a repository                       |
| TF_VAR_github_oidc_provider_url    |          | token.actions.githubusercontent.com       | The github oidc provider URL. Will also be used as the name of the identity provider in aws      |
| TF_VAR_github_oidc_audience        |          | sts.amazonaws.com                         | The github oidc audience required for permissions scope                                          |
| TF_VAR_github_oidc_thumbprint      |          | cf23df2207d99a74fbe169e3eba035e633b65d94  | The thumbprint id for github oidc. This is a temporary dummy id since it's required but not used |
___

## Terraform State S3 Bucket
This terraform requires an s3 bucket to write it's state out to so that multiple people can work on the same terraform if it needs to be updated in the future on an account.

* **Name:** whatever-you-would-like
* **Region:** pick the same region as **TF_VAR_region**

**Important Note:** make sure that the terraform role has access to this bucket otherwise terraform init will fail
___

## Terraform Role, User, and Policy

### Terraform Role Trust Relationship
Create an IAM role with the following trust relationship.

| Variable   | Description        |
|------------|--------------------|
| account_id | The target account |

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::{account_id}:root"
            },
            "Action": "sts:AssumeRole",
            "Condition": {}
        }
    ]
}
```
___
### Terraform Role Policy
This policy will define what the terraform role has access to. Should be attached to the same role as the trust relationship

_TODO: Restrict to just required permissions_

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
```
___
### Terraform User Policy
Create the following policy and attach it to a user.

| Variable   | Description                    |
|------------|--------------------------------|
| account_id | The target account             |
| role_name  | The name of the terraform role |

```json
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": [
            "arn:aws:iam::{account_id}:role/{role_name}"
        ]
    }
}
```
___

## Terraform

### Setup
1. Make a copy of the file ".tmpl/main.tf.tmpl" and place it in the parent of the tmpl folder.
2. Replace the template placeholders in the main.tf.tmpl file with their actual values. The main.tf file is ignored by git. See .tmpl/README.md for more information.
3. Create the S3 bucket outlined above in **Terraform State S3 Bucket**
4. Create the Role, User, and Policy required outlined above in **Terraform Role, User, and Policy**
5. Export with values the required terraform variables in the shell session you plan to use for the terraform command. See **Environment Variables** above for more information.
    ```bash
   # values below are example values
   export AWS_PROFILE=aws_config_role_profile
   export TF_VAR_account_id=123456789012
   export TF_VAR_github_org=myorg
   export TF_VAR_github_repo_name=cicd-repo
   ```
___
### Run
1. cd into the root of the terraform folder if not already there and perform the following command:
    ```bash
   $ terraform init
    
    Initializing the backend...
    
    Successfully configured the backend "s3"! Terraform will automatically
    use this backend unless the backend configuration changes.
    
    Initializing provider plugins...
    - Finding hashicorp/aws versions matching "~> 5.22.0"...
    - Installing hashicorp/aws v5.22.0...
    - Installed hashicorp/aws v5.22.0 (signed by HashiCorp)
    
    Terraform has created a lock file .terraform.lock.hcl to record the provider
    selections it made above. Include this file in your version control repository
    so that Terraform can guarantee to make the same selections by default when
    you run "terraform init" in the future.
    
    Terraform has been successfully initialized!
    ```

   If you see output similar to above terraform has been initialized successfully.