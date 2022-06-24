resource "aws_codepipeline" "cicd-pipeline" {
  name     = "cicd-pipeline"
  role_arn = aws_iam_role.cicd-codepipeline-role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline-artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.codestar_connector_credentials
        FullRepositoryId = "acamara19/aws-cicd-pipeline-project"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Plan"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "cicd-pipeline-plan"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ProjectName = "cicd-pipeline-apply"
      }
    }
  }
}