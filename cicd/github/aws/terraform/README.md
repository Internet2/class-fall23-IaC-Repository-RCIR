# cicd / github / aws / terraform

## Description

---
A collection of terraform scripts a user can use to build the required infrastructure to set up a oicd connection from github to aws ecr 

## Environment Variables

---
| Env Var                            | Description                                                      |
|------------------------------------|------------------------------------------------------------------|
| AWS_ACCESS_KEY_ID                  | The access key id of the user who will assume the terraform role |
| AWS_SECRET_ACCESS_KEY              | The secret access key for the user who will assume the terraform role |
| AWS_PROFILE                        | The profile set to the terraform role configuration |
| TF_VAR_account_id                  | The account id where the terraform will run its actions |
| TF_VAR_region                      | The region where any resources for this terraform will be built |
| TF_VAR_role_name                   | The name of the terraform role (at the end of the arn) |
| TF_VAR_github_repo_name            | The name of the github repository. Will also be used for the name of the ecr repository |
| TF_VAR_github_org                  | The name of the github org (or personal account) |
| TF_VAR_github_oicd_role_name       | The name of the role used for github oicd |
| TF_VAR_github_oicd_ecr_policy_name | The name of the policy used to give oicd access to ecr |
| TF_VAR_github_oicd_event_access    | The string used to filter the allowed github event actions in a repository |
| TF_VAR_github_oicd_provider_url | The github oicd provider URL. Will also be used as the name of the identity provider in aws |

---
## IAM Setup

-----
### Terraform Role Setup

**Trust relationship**

| Variable | Description |
| -------- | ----------- |
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

**Policy**

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

### Terraform User

**Policy**

| Variable | Description |
| -------- | ----------- |
| account_id | The target account |
| role_name | The name of the terraform role |

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