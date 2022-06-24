resource "aws_iam_role" "cicd-codepipeline-role" {
  name = "cicd-codepipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "cicd-codepipeline-policies" {
  statement {
    sid       = ""
    actions   = ["codestar-connections:UseConnection"]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    sid       = ""
    actions   = ["cloudwatch:*", "s3:*", "codebuild:*"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "cicd-codepipeline-policy" {
  name        = "cicd-codepipeline-policy"
  path        = "/"
  description = "Pipeline policy"
  policy      = data.aws_iam_policy_document.cicd-codepipeline-policies.json
}

resource "aws_iam_role_policy_attachment" "cicd-codepipeline-role-attachment" {
  role       = aws_iam_role.cicd-codepipeline-role.id
  policy_arn = aws_iam_policy.cicd-codepipeline-policy.arn
}

resource "aws_iam_role" "cicd-codebuild-role" {
  name = "cicd-codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "cicd-codebuild-policies" {
  statement {
    sid       = ""
    actions   = ["logs:*", "s3:*", "codebuild:*", "secretsmanager:*", "iam:*"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "cicd-codebuild-policy" {
  name        = "cicd-codebuild-policy"
  path        = "/"
  description = "Codebuild policy"
  policy      = data.aws_iam_policy_document.cicd-codebuild-policies.json
}

resource "aws_iam_role_policy_attachment" "cicd-codebuild-attachment1" {
  policy_arn = aws_iam_policy.cicd-codebuild-policy.arn
  role       = aws_iam_role.cicd-codebuild-role.id
}

resource "aws_iam_role_policy_attachment" "cicd-codebuild-attachment2" {
  policy_arn = aws_iam_policy.cicd-codebuild-policy.arn
  role       = aws_iam_role.cicd-codebuild-role.id
}