# CLASS advanced Fall 2023 - Research Computing IaC Repository (RCIR)

## Working Space

- Some helpful links:
  - [RAD Lab](<https://github.com/GoogleCloudPlatform/rad-lab>)

  - [HPC Toolkit](<https://github.com/GoogleCloudPlatform/hpc-toolkit>)

  - [EKS Cluster](<https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks>)

## Open Questions

* What's the best way to organize templates across classes (terraform, yml, containers, cfgs etc.) ?

* How should high level variables (environment, path, instance etc) be handled?

* What is the best way to stitch together the various components that make up a use case? (terraform, ansible, bash, python, containers etc.)

* Is there a need to host conatiner dockerfiles in the repo? 

* What are the best practices for storing tf state file ?

* How can we handle Ansible inventory files in a scalable way?


## Table of Contents

- [Overview](#overview)
- [Technology Stack](#technology-stack)
- [Repository Structure](#repository-structure)
  - [Root](#root)
  - [GitHub Workflows](#github-workflows)
  - [Documentation](#documentation)
  - [Templates](#templates)
    - [AWS](#aws)
    - [GCP](#gcp)
  - [Use-Cases](#use-cases)
  - [Containers](#containers)
  - [Scripts](#scripts)
  - [Environments](#environments)
- [Getting Started](#getting-started)
- [Design Considerations](#design-considerations)
- [Contribution Guidelines](#contribution-guidelines)
- [License](#license)

## Overview

This repository provides Infrastructure as Code (IaC) templates and use-case implementations for research computing. It's designed for extensibility, cloud-agnosticism, and community contributions. Initially focused on AWS, GCP and Azure but will be extended to cover more providers in the future.

## Technology Stack

- **Python**: Scripting and automation.
- **Docker**: Containerization.
- **Terraform**: IaC.
- **Ansible**: Configuration management.
- **Bash**: Shell scripting.
- **Ubuntu**: Base OS.

## Repository Structure

### Root

- `README.md`: This document.
- `LICENSE`: License information.
- `.gitignore`: Git ignore rules.

### GitHub Workflows

- `.github/workflows/ci-cd.yml`: CI/CD pipeline.

### Documentation

- `docs/getting-started.md`: Quickstart guide.

### Templates

#### AWS

- `templates/cloud_providers/aws/terraform`: Terraform for AWS.
- `templates/cloud_providers/aws/ansible`: Ansible for AWS.

#### GCP

- `templates/cloud_providers/gcp/terraform`: Terraform for GCP.
- `templates/cloud_providers/gcp/ansible`: Ansible for GCP.

### Use-Cases

- `use-cases/secure-storage`: Secure storage solutions.
- `use-cases/kubernetes-cluster`: Kubernetes setups.
- `use-cases/containerized-workflows`: Containerized workflows.

### Containers

- `containers/scientific_computing/container_1/Dockerfile`: Example Dockerfile.

### Scripts

- `scripts/bash`: Bash scripts.
- `scripts/python`: Python scripts.

### Environments

- `environments/aws`: AWS-specific configs.
- `environments/gcp`: GCP-specific configs.
- `environments/azure`: Azure-specific configs.

## Getting Started

1. **Clone**: `git clone https://github.com/your-repo.git`
2. **Navigate**: `cd your-repo`
3. **Install**: Follow READMEs in each directory.
4. **Run**: Use Bash or Python scripts.
5. **Deploy**: Use Terraform or Ansible.

## Design Considerations

- **Modularity**: Reusable templates.
- **Documentation**: Well-documented.
- **Version Control**: Semantic versioning.
- **Testing**: Automated tests.
- **Security**: Secure coding.
- **Cloud Agnosticism**: Cloud-agnostic.
- **Code Reviews**: PRs and code reviews.

## Contribution Guidelines

See [Contribution Guidelines](CONTRIBUTING.md).

## License

## Acknowledgements
This project was developed as part of the Internet2 CLASS program with contributions from participants at the Washington University in St. Louis, NC State University, UC San Diego, CU Boulder, Ohio State University, National Center for Atmospheric Research, Yale, Northwestern University, University of North Carolina at Chapel Hill and UC Riverside. 

Contact: class@internet2.edu


---
