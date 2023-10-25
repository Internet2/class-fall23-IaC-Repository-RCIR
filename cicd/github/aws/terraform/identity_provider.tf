resource "aws_iam_openid_connect_provider" "default" {
  url = "https://${var.github_oidc_provider_url}"

  client_id_list = [var.github_oidc_audience]

  thumbprint_list = [var.github_oidc_thumbprint]

  tags = merge(local.tags, {})
}