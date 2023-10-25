resource "aws_iam_policy" "github_oicd_ecr_policy" {
  name = var.github_oicd_ecr_policy_name
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
}

# the role github oicd will use
resource "aws_iam_role" "github_oicd_role" {
  name = var.github_oicd_role_name
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${var.account_id}:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:${var.github_org}/${var.github_repo_name}:${var.github_event_access}"
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "github_oicd_role_policy_attach" {
  role       = aws_iam_role.github_oicd_role.name
  policy_arn = aws_iam_policy.github_oicd_ecr_policy.arn
}