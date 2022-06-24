resource "aws_ecr_repository" "cicd-pipeline-ecr-repo" {
  name                 = "cicd-pipeline-ecr-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}