resource "aws_s3_bucket" "codepipeline-artifacts" {
  bucket = "aws-cicd-pipeline-artifacts"
}

resource "aws_s3_bucket_acl" "codepipeline-artifacts-acl" {
  bucket = aws_s3_bucket.codepipeline-artifacts.id
  acl    = "private"
}