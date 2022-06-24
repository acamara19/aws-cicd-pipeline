resource "aws_codebuild_project" "cicd-pipeline-project" {
  name          = "cicd-pipeline-project"
  description   = "cicd_codebuild_project"
  service_role  = aws_iam_role.cicd-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "us-east-1"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.AWS_ACCOUNT_ID
    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = aws_ecr_repository.cicd-pipeline-ecr-repo.name
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "cicd-codebuild"
      stream_name = "cicd-pipeline"
    }
  }

  source {
    type            = "CODEPIPELINE"
    location        = "https://github.com/acamara19/aws-cicd-pipeline-project.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }
}