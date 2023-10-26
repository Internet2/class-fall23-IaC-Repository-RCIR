# cicd / github

## Description
This readme provides information relating to the overall architecture of the terraform and github workflows for both
GCP and AWS.

## Pipeline Visualization
Below is a quick process flow chart detailing the various pieces of the proposed CICD chain. Currently the terraform and
workflow files support up to pushing the built image into ECR and setting up the infrastructure to that point. Ideally
this workflow (using AWS as an example) would continue to extend until it is deployed via event bridge and lambda then
deployed to ECS or EKS.

Both supported clouds (GCP and AWS) have workflows that can build, login, and push images to their respective registries
if already set up. Both AWS and GCP have supporting terraform files.

![CICD Pipeline Visualization](CICD%20Pipeline%20Visualization.png)