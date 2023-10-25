# cicd / github / aws

## Description
This section contains all the required files pertaining to constructing a CI/CD pipeline from Github to AWS ECR

## Contents
| Item      | Description                                                                                                    |
|-----------|----------------------------------------------------------------------------------------------------------------|
| terraform | contains the various terraform pieces to set up an AWS account to work with github oicd and deploy to ECR      |
| workflow  | the requisuite github workflow files that build a docker image, log in to AWS ecr, and pushes the build to ECR |
