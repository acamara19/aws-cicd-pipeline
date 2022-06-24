resource "aws_vpc" "cicd-main" {
  cidr_block = "10.16.0.0/24"
}