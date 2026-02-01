data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.github.url
}

data "aws_iam_policy_document" "github" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      identifiers = [aws_iam_openid_connect_provider.github.arn]
      type        = "Federated"
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:erryasri/Caprover-with-DevSecOps-Terraform:*"]
    }
  }
}

resource "aws_iam_role" "github" {
  name               = "GitHub-Role"
  assume_role_policy = data.aws_iam_policy_document.github.json

  tags = merge(var.tags, {
    "Owner" = "DevOps-Team"
  })
}

data "aws_iam_policy_document" "s3_terraform_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }
}

resource "aws_iam_role_policy" "s3_terraform_policy" {
  name   = "Github-State-Policy"
  role   = aws_iam_role.github.id
  policy = data.aws_iam_policy_document.s3_terraform_policy.json
}