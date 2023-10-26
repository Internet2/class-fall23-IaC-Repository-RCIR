# cicd / github / aws / workflow

## Description
This folder houses the Github workflow file that helps facilitate the parts of the process that sit outside of the cloud
in Github. This workflow accomplishes a few things:

1. Clones the repository to a temporary machine
2. Configures the aws credentials via Github OIDC (see the terraform folder and below for more information)
3. Logs into ECR with the credentials from the previous step
4. Extracts meta data about the image that will be built and sets up semantic versioning
5. Builds the image and pushes the image up to the ECR repository with the required tags
___

## Trigger Conditions
The Github workflow contained here out of the box corresponds with the Github OIDC trust relationship role specified in
the terraform. It will only trigger when a release has been made and has a status of published. This works for both pre
releases and regular releases. Under the hood in the AWS Role the trust relationship will allow any github event that
creates a tag. With both of those conditions it will be successful. Releases should follow semantic version in order to
work correctly. See: [Semver](https://semver.org/)
___

## Repository Variables
The following variables are required in order for the workflow to work properly. These variables should be defined on
the repository level and not in an environment. Environments require a different trust relationship subject. See:
 [Configuring the role and trust policy](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#configuring-the-role-and-trust-policy)

| Variable         | Description                                                                          |
|------------------|--------------------------------------------------------------------------------------|
| AWS_REGION       | The AWS region the ECR repository is located                                         |
| AWS_ACCOUNT      | The AWS account where the ECR repository is located                                  |
| AWS_ROLE         | The name of the AWS role that is attached to the Github OIDC                         |
| AWS_REPO         | The name of the AWS ECR repository. Should be the same as the github repository name | 
| AWS_SESSION_NAME | The name of the session when assuming the role to deploy to AWS ECR. User defined.   |