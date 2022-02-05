# One bucket for all warship application pipelines

resource "aws_s3_bucket" "warship_pipelines" {
  bucket        = "warship-pipelines"
  acl           = "private"
  force_destroy = true
}
