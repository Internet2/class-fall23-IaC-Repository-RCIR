resource "aws_iam_policy" "default" {
  name = var.github_oidc_ecr_policy_name
  description = "The policies in order to deploy to ECR and access kms"
  path = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:BatchGetImage",
                "ecr:GetLifecyclePolicy",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:ListTagsForResource",
                "ecr:DescribeImageScanFindings",
                "ecr:DescribeRepositories",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:PutImage"
            ],
            "Resource": "arn:aws:ecr:us-east-1:${var.account_id}:repository/${var.github_repo_name}"
        }
    ]
}
EOF
  tags = merge(local.tags, {})
}

# the role github oidc will use
resource "aws_iam_role" "default" {
  name = var.github_oidc_role_name
  path = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${var.account_id}:oidc-provider/${var.github_oidc_provider_url}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "${var.github_oidc_provider_url}:aud": "${var.github_oidc_audience}"
                },
                "StringLike": {
                    "${var.github_oidc_provider_url}:sub": "repo:${var.github_org}/${var.github_repo_name}:${var.github_oidc_event_access}"
                }
            }
        }
    ]
}
EOF
  tags = merge(local.tags, {})
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}