# cicd / github / gcp

## Description
This section contains all the required files pertaining to constructing a CI/CD pipeline from Github to GCP Artifact 
Registry
___

## Contents
| Item      | Description                                                                                                            |
|-----------|------------------------------------------------------------------------------------------------------------------------|
| terraform | contains the various terraform pieces to set up a GCP project to work with github oicd and deploy to artifact registry |
| workflow  | the requisite github workflow files that build a docker image, login to GCP, and pushes the build to artifact registry |
