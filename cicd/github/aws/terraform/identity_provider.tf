resource "aws_iam_openid_connect_provider" "github_oidc_identity" {
  url = var.github_oidc_provider_url

  client_id_list = [var.github_oidc_audience]

  thumbprint_list = [var.github_oidc_thumbprint]
}